{ config, pkgs,lib, catppuccin-bat, ...}:
{
  
  # user softwares
  home.packages = with pkgs;[
    neofetch
    nnn

    # archives
    zip
    unzip
    p7zip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    eza # A modern replacement for 'ls'
    fzf # A command-line fuzzy finder

    # networking tools
    mtr # A network diagnostic tool
    iperf3
    dnsutils # 'dig' + 'nslookup'
    ldns # replacement of 'dig', it provide the command 'drill'
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc # it is a calculator for the IPv4/v6 address

    # misc
    which
    tree
    libnotify
    whineWowPackages.wayland
    xdg-utils
    graphviz

    # cloud native

    # nix related
    # it provides the command 'nom' works just like 'nix'
    # with more details log output
    nix-output-monitor

    # productivity
    obisidian
    glow # markdown perviewer in terminal
    btop # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for 'sensors' command
    ethtool 
    pciutils # lspci
    usbutils # lsusb
  ];

  programs = {
    bat = {
	enable = true;
	config = {
	  paper = "less -FR";
	  theme = "catppuccin-mocha";
	};
	themes = {
	  catppuccin-mocha = {
	    src = catppuccin-bat;
	    file = "Catppuccin-mocha.tmTheme";
	  };
	};
    };

    alacritty = {
     enable = true;
     settings = {
       env.TERM = "xterm-256color";
       font = {
         size = 12;
         draw_bold_text_with_bright_colors = true;
       };
       scrolling.multiplier = 5;
       selection.save_to_clipboard = true;
     };
    };

    starship = {
      enable = true;
      settings = {
        add_newline = false;
        aws.disabled = true;
        gcloud.disabled = true;
        line_break.diabled = true;
      };
    };

  };
}
