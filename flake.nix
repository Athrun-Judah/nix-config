
{
	description = "Nixos flake";
	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
# flake-utils.url = "github:numtide/flake-utils";
		home-manager = {
			url = "github:nix-community/home-manager/release-24.05";
# The 'follows' keyword in inputs is used for inheritance.
# Here, 'inputs.nixpkgs' of home-manager is kept consistent with
# the 'inputs.nixpkgs' of the current flake,
# to avoid problems caused by different versions of nixpkgs.
			inputs.nixpkgs.follows = "nixpkgs";
		};
		rust-overlay = {
			url = "github:oxalica/rust-overlay";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		catppuccin-bat = {
			url = "github:catppuccin/bat";
			flake = false;
		};
	};

	outputs = inputs@{ self, nixpkgs, home-manager, flake-utils, rust-overlay, ... }: 
		let
		supportedSystems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];	
	forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
			pkgs = import nixpkgs {
			inherit system;
			overlays = [rust-overlay.overlays.default self.overlays.default];
			};
			});
	in
	{
		overlays.default = final: prev: {
			rustToolchain = 
				let
				rust = prev.rust-bin;
			in
				if builtins.pathExists ./rust-toolchain.toml then
					rust.fromRustupToolchainFile ./rust-toolchain.toml
				else if builtins.pathExists ./rust-toolchain then
					rust.fromRustupToolchainFile ./rust-toolchain
				else
					rust.stable.latest.default.override {
						extensions = ["rust-src" "rustfmt"];
					};
		};
		devShells = forEachSupportedSystem ({pkgs}: {
				default = pkgs.mkShell {
				packages = with pkgs; [
				rustToolchain
				openssl
				pkg-config
				cargo-deny
				cargo-edit
				cargo-watch
				rust-analyzer
				];
				env = {
				RUST_SRC_PATH = "${pkgs.rustToolchain}/lib/rustlib/src/rust/library";
				};

				};
});		


		nixosConfigurations = {
# host name
			grace = let
				username = "grace";
				system = "x86_64-linux";
			specialArgs = { inherit username; };
			in
				nixpkgs.lib.nixosSystem {
					inherit system specialArgs ; 
# system = "x86_64-linux";
					modules = [
						./configuration.nix
							home-manager.nixosModules.home-manager
							{
								home-manager.useGlobalPkgs = true;
								home-manager.useUserPackages = true;
								home-manager.users.${username} = import ./users/${username}/home.nix;
								home-manager.extraSpecialArgs = inputs // specialArgs;
							}
					];
				};
		};

	};
}
