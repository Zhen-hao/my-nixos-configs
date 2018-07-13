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
  #networking.networkmanager.enable = true;

  networking.enableB43Firmware = true;

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enabled = "fcitx";
      ibus.engines = with pkgs.fcitx-engines; [ chewing ];
    };
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


  fonts = {
    enableCoreFonts = true;
    enableFontDir = true;
    enableGhostscriptFonts = false;

    fonts = with pkgs; [
      symbola
      font-awesome-ttf
      libertine
      # code2000
      # code2001
      # code2002
      terminus_font
      ubuntu_font_family
      liberation_ttf
      freefont_ttf
      source-code-pro
      (let inconsolata-lgc  = let version = "1.2.0";
           in with pkgs; stdenv.mkDerivation rec {
             name = "inconsolata-lgc-${version}";
             src = fetchurl {
               url = "https://github.com/MihailJP/Inconsolata-LGC/releases/download/LGC-1.2.0/InconsolataLGC-OT-1.2.0.tar.xz";
               sha256 = "0rw8i481sdqi0pspbvyd2f86k0vlrb6mbi94jmsl1kms18c18p66";
             };
             dontBuild = true;
             installPhase = let
               fonts_dir = "$out/share/fonts/opentype";
               doc_dir = "$out/share/doc/${name}";
             in ''
               mkdir -pv "${fonts_dir}"
               mkdir -pv "${doc_dir}"
               cp -v *.otf "${fonts_dir}"
               cp -v {README,LICENSE,ChangeLog} "${doc_dir}"
             '';
             meta = with stdenv.lib; {
               homepage = http://www.levien.com/type/myfonts/inconsolata.html;
               description = "A monospace font for both screen and print, LGC extension";
               license = licenses.ofl;
               platforms = platforms.all;
             };
           }; in inconsolata-lgc)
      inconsolata
      vistafonts
      dejavu_fonts
      freefont_ttf
      unifont
      cm_unicode
      ipafont
      baekmuk-ttf
      source-han-sans-japanese
      source-han-sans-korean
      source-han-sans-simplified-chinese
      source-han-sans-traditional-chinese
      source-sans-pro
      source-serif-pro
      fira
      fira-code
      fira-mono
      hasklig
    ];
    fontconfig = {
      enable = true;
      dpi = 200;
      antialias = true;
      hinting = {
        autohint = false;
        enable = true;
        #style = "slight";
      };
      subpixel.lcdfilter = "default";
      ultimate = {
        enable = true; # see also: rendering, substitutions
      };
      defaultFonts = {
        serif = [ "Source Sans Pro" "DejaVu Serif" "IPAMincho" "Beakmuk Batang" ];
        sansSerif = [ "Source Serif Pro" "DejaVu Sans" "IPAGothic" "Beakmuk Dotum" ];
        monospace = [ "Inconsolata LGC" "DejaVu Sans Mono" "IPAGothic" "Beakmuk Dotum" ];
      };
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
    # brosers
    firefoxWrapper
    chromium

    wget # download tool

    # editors
    vim
 	  atom

    # source control for configs etc
    gitAndTools.gitFull # git source control
    gitAndTools.gitRemoteGcrypt # encrypted git remotes

    unzip # An extraction utility for archives compressed in .zip format
    wpa_supplicant_gui # WiFi tool
    plasma-nm
    # networkmanager
    blueman #Bluetooth

  	aspellDicts.en # spelling check
  	slack # company chat

  	# Dev
    openjdk # Java
  	jetbrains.idea-community
    sbt

  	# Data Science
  	RStudio-with-my-packages

    maim # screenshot
    xclip # send data to the clipboard
    gnupg # Modern (2.1) release of the GNU Privacy Guard, a GPL OpenPGP implementation
    htop # An interactive process viewer for Linux
    usbutils # Tools for working with USB devices, such as lsusb
    smartmontools   # Tools for monitoring the health of hard drives - smartctl etc
    pciutils # A collection of programs for inspecting and manipulating configuration of PCI devices
    lshw # Provide detailed information on the hardware configuration of the machine
    hwinfo # Hardware detection tool from openSUSE
    sysfsutils # These are a set of utilites built upon sysfs, a new virtual filesystem in Linux kernel versions 2.5+ that exposes a system's device tree.
    nmap #port scanning

    strongswan #P2S VPN
    networkmanager_strongswan
    openssl

    # KDE Tools
    kdeApplications.spectacle

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

  # VPN
  services.strongswan.enable = true;
  services.strongswan.secrets = [ "/run/keys/ipsec.secret" ];

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.gutenprint pkgs.gutenprintBin pkgs.cups-bjnp pkgs.foomatic-filters ];
  services.avahi.enable = true;
  services.avahi.nssmdns = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    # NixOS allows either a lightweight build (default) or full build of PulseAudio to be installed.
    # Only the full build has Bluetooth support, so it must be selected here.
    package = pkgs.pulseaudioFull;
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.extraConfig = "
[General]
ControllerMode = bredr
Disable=Socket
Disable=Headset
Enable=Media,Source,Sink,Gateway
AutoConnect=true
load-module module-switch-on-connect

  "; # Disable=Socket

  # hardware.pulseaudio.configFile = pkgs.writeText "default.pa" ''
    # load-module module-bluetooth-policy
    # load-module module-bluetooth-discover
    ## module fails to load with
    ##   module-bluez5-device.c: Failed to get device path from module arguments
    ##   module.c: Failed to load module "module-bluez5-device" (argument: ""): initialization failed.
    # load-module module-bluez5-device
    # load-module module-bluez5-discover
 # '';


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
	  extraGroups = [ "wheel" "networkmanager" "audio"];
	};

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?

}
