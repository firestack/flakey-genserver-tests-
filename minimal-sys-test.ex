defmodule Test.GenServer do
  use GenServer

  def start_link(opts), do: GenServer.start_link(__MODULE__, opts)

  def call(pid), do: GenServer.call(pid, :reset_timeout)

  @impl GenServer
  def init(opts) do
    {:ok, Keyword.take(opts, [:timeout])}
  end

  @impl GenServer
  def handle_call(:reset_timeout, _from, state) do
    {:reply, :ok, state, get_timeout(state)}
  end

  @impl GenServer
  def handle_info(:timeout, state), do: {:noreply, state}

  defp get_timeout(state), do: state[:timeout]
end

defmodule Test.Support.GenServer do
  import ExUnit.Assertions

  def assert_genserver_timeout(server_pid) do
    trace_message = install_genserver_timeout_trace(server_pid)

    assert_receive ^trace_message
  end

  def refute_genserver_timeout(server_pid) do
    trace_message = install_genserver_timeout_trace(server_pid)

    refute_receive ^trace_message
  end

  defp install_genserver_timeout_trace(server_pid) do
    test_pid = self()
    trace_message = {:trace, make_ref()}

    # :sys.suspend(server_pid)
    # We need to wait till the GenServer processes our timeout,
    # GenServer sends a `system_event/0` with `{:in, :timeout}` when the timeout fires
    # but that doesn't mean that the code running in the timeout has finished.
    #
    # `process_genserver_timeout_system_message` first waits till the timeout
    # has started, then sends a message to the test process once the timeout
    # handler has finished and returns :noreply
    :ok =
      :sys.install(
        server_pid,
        {&process_genserver_timeout_system_message/3,
         %{status: :awaiting_timeout, on_done: fn -> send(test_pid, trace_message) end}}
      )

    # :sys.resume(server_pid)
    trace_message
  end

  defp process_genserver_timeout_system_message(
         %{status: :awaiting_timeout} = state,
         {:in, :timeout},
         _state
       ),
       do: %{state | status: :awaiting_response}

  defp process_genserver_timeout_system_message(
         %{status: :awaiting_response, on_done: on_done},
         {:noreply, _},
         _state
       ) do
    on_done.()

    :done
  end

  defp process_genserver_timeout_system_message(acc, _system_message, _state),
    do: acc
end

# Configure and Start ExUnit application but don't run tests yet
ExUnit.start(
  # Print tests as they run
  #   trace: true,

  # Run Tests in order of definition
  seed: 0,

  # Don't run tests yet
  autorun: false
)

# Define Tests
for i <- 1..1000 do
  defmodule Module.concat([Test, "TimeoutTest", to_string(i)]) do
    use ExUnit.Case, async: true
    import Test.Support.GenServer

    test "assert_timeout" do
      pid = start_link_supervised!({Test.GenServer, [timeout: 1]})
      Test.GenServer.call(pid)
      assert_genserver_timeout(pid)
    end

    test "refute_timeout" do
      pid = start_link_supervised!({Test.GenServer, [timeout: 1]})
      refute_genserver_timeout(pid)
    end
  end
end

# Run Tests
ExUnit.run()
