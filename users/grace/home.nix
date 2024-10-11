{ pkgs, ...}:

{
	imports = [
		../../home/core.nix
		../../home/programs
	];

	programs.git = {
		userName = "athrun";
		userEmail = "athrun.judah@proton.me";
	};
}
