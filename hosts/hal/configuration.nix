{ config, pkgs, ... }:

let
  dieselRepo = /mnt/vmstore/projetos/diesel-os-lab;
  dieselUiName = "Diesel Plasma Lab";
  dieselPrettyName = "Diesel Plasma Lab — Technology & Gaming Platform";

  dieselLogo = dieselRepo + /assets/branding/logo/diesel-os-lab-icon.png;
  dieselSplash = dieselRepo + /assets/branding/splash/diesel-os-lab-splash-dark-v2-fixed.png;
  dieselAvatar = dieselRepo + /assets/branding/avatar/diesel-os-lab-avatar-github-v2.png;
  dieselWallpaper = dieselRepo + /assets/branding/wallpaper/diesel-os-lab-wallpaper-dark-1080p-v3.jpg;

  dieselBrandingAssets = pkgs.runCommandLocal "diesel-plasma-lab-branding-assets" { } ''
    mkdir -p $out/share/diesel-plasma-lab
    mkdir -p $out/share/icons/hicolor/512x512/apps

    cp ${dieselLogo} $out/share/diesel-plasma-lab/logo.png
    cp ${dieselSplash} $out/share/diesel-plasma-lab/splash.png
    cp ${dieselAvatar} $out/share/diesel-plasma-lab/avatar.png
    cp ${dieselWallpaper} $out/share/diesel-plasma-lab/wallpaper.jpg

    cp ${dieselLogo} $out/share/icons/hicolor/512x512/apps/diesel-plasma-lab.png
    cp ${dieselLogo} $out/share/icons/hicolor/512x512/apps/diesel-os-lab.png
  '';

  pinnedZenPkgs = import
    (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/d215436dc2f9d64f63a2713fb8b67df85ba9f73e.tar.gz")
    {
      system = pkgs.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 0;

  boot.supportedFilesystems = [ "f2fs" "vfat" "xfs" ];
  boot.initrd.supportedFilesystems = [ "f2fs" "vfat" "xfs" ];

  boot.plymouth = {
    enable = true;
    theme = "spinner";
    logo = dieselLogo;
  };

  boot.consoleLogLevel = 3;
  boot.initrd.verbose = false;

  boot.kernelPackages = pinnedZenPkgs.linuxPackages_zen;

  boot.kernelParams = [
    "quiet"
    "splash"
    "udev.log_level=3"
    "systemd.show_status=auto"
    "nvidia-drm.modeset=1"
  ];

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
  };

  zramSwap = {
    enable = true;
    memoryPercent = 40;
  };

  fileSystems."/mnt/vmstore" = {
    device = "/dev/disk/by-uuid/7f51b176-a0d1-4213-80c4-0f58b957315e";
    fsType = "xfs";
    options = [ "nofail" "x-gvfs-show" ];
  };

  networking.hostName = "diesel-os-lab";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  time.timeZone = "America/Sao_Paulo";

  i18n.defaultLocale = "pt_BR.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  services.xserver.enable = true;

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };

  console.keyMap = "br-abnt2";

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    powerManagement.enable = false;
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "595.58.03";
      sha256_64bit = "sha256-jA1Plnt5MsSrVxQnKu6BAzkrCnAskq+lVRdtNiBYKfk=";
      sha256_aarch64 = "sha256-hzzIKY1Te8QkCBWR+H5k1FB/HK1UgGhai6cl3wEaPT8=";
      openSha256 = "sha256-6LvJyT0cMXGS290Dh8hd9rc+nYZqBzDIlItOFk8S4n8=";
      settingsSha256 = "sha256-2vLF5Evl2D6tRQJo0uUyY3tpWqjvJQ0/Rpxan3NOD3c=";
      persistencedSha256 = "sha256-AtjM/ml/ngZil8DMYNH+P111ohuk9mWw5t4z7CHjPWw=";
    };
  };

  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    (final: prev: {
      libfprint = prev.libfprint.overrideAttrs (oldAttrs: {
        version = "git";
        src = final.fetchFromGitHub {
          owner = "deftdawg";
          repo = "libfprint-CS9711";
          rev = "56bf490f8ea2ab9049f410b9dfe78b33d59fd2c4";
          sha256 = "sha256-PVr/Mi3m0P1bojVYriubmpA8QC5oayV5RtHbyXyHPC0=";
        };
        nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [
          final.opencv
          final.cmake
          final.doctest
        ];
      });
    })
  ];

  system.nixos.distroName = dieselUiName;
  system.nixos.vendorName = dieselUiName;
  system.nixos.extraOSReleaseArgs = {
    PRETTY_NAME = "Diesel Plasma Lab - Technology and Gaming Platform";
    FANCY_NAME = dieselPrettyName;
    DEFAULT_HOSTNAME = "diesel-os-lab";
    LOGO = "diesel-plasma-lab";
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  programs.gamemode.enable = true;
  programs.dconf.enable = true;
  programs.firefox.enable = true;
  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    kdePackages.bluedevil
    brave
    fluent-icon-theme
    micro
    git
    mangohud
  ];

  services.fstrim.enable = true;
  services.flatpak.enable = true;
  services.fprintd.enable = true;
  services.ratbagd.enable = true;
  services.lact.enable = true;

  systemd.services.flatpak-repo = {
    description = "Configurar Flathub globalmente";
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    path = [ pkgs.flatpak ];
    serviceConfig = {
      Type = "oneshot";
    };
    script = ''
      flatpak remote-add --if-not-exists --system flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    '';
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu.swtpm.enable = true;
  };

  virtualisation.spiceUSBRedirection.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };

  users.users.hal = {
    isNormalUser = true;
    description = "hal";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "kvm" ];
  };

  system.activationScripts.dieselHalAvatar = ''
    mkdir -p /var/lib/AccountsService/icons
    mkdir -p /var/lib/AccountsService/users

    cp ${dieselBrandingAssets}/share/diesel-plasma-lab/avatar.png /var/lib/AccountsService/icons/hal

    cat > /var/lib/AccountsService/users/hal <<EOF2
[User]
Icon=/var/lib/AccountsService/icons/hal
SystemAccount=false
EOF2

    chmod 644 /var/lib/AccountsService/icons/hal
    chmod 644 /var/lib/AccountsService/users/hal
  '';

  systemd.user.services.diesel-plasma-wallpaper = {
    description = "Diesel Plasma Lab first login wallpaper setup";
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    path = [ pkgs.kdePackages.plasma-workspace pkgs.coreutils pkgs.bash ];
    serviceConfig = {
      Type = "oneshot";
    };
    script = ''
      stamp="$HOME/.local/state/diesel-plasma-lab/wallpaper-applied"

      if [ -e "$stamp" ]; then
        exit 0
      fi

      mkdir -p "$(dirname "$stamp")"

      if command -v plasma-apply-wallpaperimage >/dev/null 2>&1; then
        plasma-apply-wallpaperimage "${dieselBrandingAssets}/share/diesel-plasma-lab/wallpaper.jpg"
        touch "$stamp"
      fi
    '';
  };

  system.stateVersion = "25.11";
}
