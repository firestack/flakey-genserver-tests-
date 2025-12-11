let

	beam = builtins.getFlake "github:elixir-tools/nix-beam-flakes";
	nixpkgs =
		import <nixpkgs> {};
		# import beam.inputs.nixpkgs {};

	tool-versions = (beam.lib.parseToolVersions ./.tool-versions);
	beamPackages = beam.lib.mkPackageSet {
		pkgs = nixpkgs;
		elixirVersion = beam.lib.normalizeElixir tool-versions.elixir;
		erlangVersion = tool-versions.erlang;
		elixirLanguageServer = true;
	};
in
	nixpkgs.mkShell {
		packages = [
			nixpkgs.entr
			beamPackages.elixir
			beamPackages.elixir-ls
			beamPackages.erlang
		];
	}
