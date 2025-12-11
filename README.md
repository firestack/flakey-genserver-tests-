# Run the tests
```
elixir ./minimal-sys-test.ex
```

# Example error
```
  1) test assert_timeout (:"Elixir.Test.TimeoutTest.13")
     minimal-sys-test.ex:101
     Assertion failed, no matching message after 100ms
     The following variables were pinned:
       trace_message = {:trace, #Reference<0.3575462961.2162950146.137276>}
     The process mailbox is empty.
     code: assert_receive ^trace_message
     stacktrace:
       minimal-sys-test.ex:30: Test.Support.GenServer.assert_genserver_timeout/1
       minimal-sys-test.ex:104: (test)



  2) test assert_timeout (:"Elixir.Test.TimeoutTest.9")
     minimal-sys-test.ex:101
     Assertion failed, no matching message after 100ms
     The following variables were pinned:
       trace_message = {:trace, #Reference<0.3575462961.2162950147.137259>}
     The process mailbox is empty.
     code: assert_receive ^trace_message
     stacktrace:
       minimal-sys-test.ex:30: Test.Support.GenServer.assert_genserver_timeout/1
       minimal-sys-test.ex:104: (test)



  3) test assert_timeout (:"Elixir.Test.TimeoutTest.3")
     minimal-sys-test.ex:101
     Assertion failed, no matching message after 100ms
     The following variables were pinned:
       trace_message = {:trace, #Reference<0.3575462961.2162950146.137278>}
     The process mailbox is empty.
     code: assert_receive ^trace_message
     stacktrace:
       minimal-sys-test.ex:30: Test.Support.GenServer.assert_genserver_timeout/1
       minimal-sys-test.ex:104: (test)

```
