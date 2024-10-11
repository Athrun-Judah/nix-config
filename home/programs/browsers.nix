{
	pkgs,
	config,
	username,
	...
}: {
	programs = {
		firefox = {
			enable = true;
			profiles.${username} = {};
			extensions = [
				# {id = "";} // extension id, query from web store
			];
		};
	};
}
