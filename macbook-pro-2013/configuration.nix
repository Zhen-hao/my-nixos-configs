# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true; 

  networking.hostName = "nixos"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.enableB43Firmware = true;

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";


  # Set nixpkgs options
  nixpkgs.config = {

	allowUnfree = true;
	
	icedtea = true;
		
	firefox = {
		enableAdobeFlash = true;
	};

	chromium = {
		enablePepperFlash = true;
		enablePepperPDF = true;
	};

  };

  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs;
  let
        RStudio-with-my-packages = rstudioWrapper.override
                { packages = with rPackages;
                  [
                        tidyverse
                        anytime
                        jsonlite
                        zoo
                        bcp
                        DBI
                  ];
                 };
  in 
  [
    wget
    vim
 	atom
    # source control for configs etc
    
    gitAndTools.gitFull # git source control
    gitAndTools.gitRemoteGcrypt # encrypted git remotes	
	
	unzip # An extraction utility for archives compressed in .zip format
	wpa_supplicant_gui	
	
	openjdk # Java
	aspellDicts.en # spelling check	
	slack # company chat
	
	# Dev
	jetbrains.idea-community
	
	# Data Science
	RStudio-with-my-packages

	# brosers
  	pkgs.firefoxWrapper 
	pkgs.chromium  
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.bash.enableCompletion = true;
  programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 80 443 ];
  # networking.firewall.allowedTCPPortRanges = [
  # 	{ from = 4000; to = 4007; }
  # 	{ from = 8000; to = 8010; }
  # ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  
  # Light
  services.redshift.enable = true;
  services.redshift.brightness.day = "0.8";
  services.redshift.brightness.night = "0.4";
  services.redshift.latitude = "52.3702";
  services.redshift.longitude = "4.8952";
 
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e";
  
  # NVIDIA
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.driSupport32Bit = true;

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  # Enable GPU support for intel
  hardware.opengl.extraPackages = [ pkgs.vaapiIntel ]; 

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.extraUsers.guest = {
  #  isNormalUser = true;
  #   uid = 1000;
  # };

  users.users.zhenhao = 
	{ isNormalUser = true;
	  home = "/home/zhenhao";
	  description = "Zhenhao Li";
	  extraGroups = [ "wheel" "networkmanager" ];
	};

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?

}
