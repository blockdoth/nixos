# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ lib, pkgs, inputs,... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];

  boot = {
    supportedFilesystems = ["ntfs"];
    loader = {
      systemd-boot = {
        enable = false;
        editor = false;
      };

      timeout = 10;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        configurationLimit = 8;
        theme =
          pkgs.fetchFromGitHub
          {
            owner = "Lxtharia";
            repo = "minegrub-theme";
            rev = "193b3a7c3d432f8c6af10adfb465b781091f56b3";
            sha256 = "1bvkfmjzbk7pfisvmyw5gjmcqj9dab7gwd5nmvi8gs4vk72bl2ap";
          };
      };
    };
  };

  networking.hostName = "pepijn"; # Define your hostname.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  
  time.timeZone = "Europe/Amsterdam";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
    	LANGUAGE = "en_US.UTF-8";
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };
  
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;


	programs.hyprland = {
		enable = true;
		xwayland.enable = true;
		#package = inputs.hyprland.packages."${pkgs.system}".hyprland;
	};

	security.rtkit.enable = true;
	
  # Bluetooth support
  hardware = {
  	pulseaudio = {
  		enable = false;
  	  #extraModules = [ pkgs.pulseaudio-modules-bt ];
  	};
  	graphics.enable = true;
  	bluetooth = {
    	enable = true;
  	};
  };
  
  # Enable sound.
  sound = {
  	enable = true;
  	mediaKeys.enable = true;
	};
  
  services = {
  	blueman.enable = true;
  	openssh.enable = true;
  	pipewire = {
			enable = true;
			alsa.enable = true;
			alsa.support32Bit = true;
			pulse.enable = false;
			# jack.enable = true;
		};
  	libinput = {
    	enable = true;
    	touchpad = {
      	tapping = true;
      	naturalScrolling = true;
      	scrollMethod = "twofinger";
    	};
  	};
  };

  security.sudo.wheelNeedsPassword = false;
  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;
  
  nixpkgs.config = {
  	allowUnfree = true; 
  	pulseaudio = true;
  };

	programs.fish.enable = true;
  users.users.pepijn = {
		shell = pkgs.fish;
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

	
	xdg.portal = {
		enable = true;
		#extraPortals = [pkgs.xdg-desktop-portal-gtk];
	};
	
	environment.sessionVariables = {
		WLR_NO_HARDWARE_CURSORS= "1";
		NIXOS_OZONE_WL = "1";
	};
  
  home-manager = {
		backupFileExtension = "backup";
		useUserPackages = true;
		useGlobalPkgs = true;
		extraSpecialArgs = {inherit inputs;};
		users.pepijn = ../../home/laptop/home.nix;
	};

  environment.systemPackages = with pkgs; [
    git
    home-manager
  ];

  nix = {
    package = pkgs.nixFlakes;
    settings = {
    	experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      http-connections = 50;
      warn-dirty = false;
      log-lines = 50;
    };
    gc = {
      automatic = false;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  system.stateVersion = "24.05";
}

