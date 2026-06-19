{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    neovim
    fuzzel
    xwayland-satellite
    signal-desktop
    hyfetch
    fastfetch
    efibootmgr
    seahorse
    nixfmt
    git
    nautilus
    zellij
    mako
    teams-for-linux
    fnm
    uv
    wl-clipboard
    bun
    nil
    pavucontrol
    bubblewrap
    slack
    brightnessctl
    bottom
    file
    lsd
    spotify
    filezilla
    qbittorrent
    feishin
    android-studio
    theclicker
    prismlauncher
    jdk21_headless
    llm-agents.claude-code
    llm-agents.opencode
    llm-agents.codex
    pnpm
    zen-browser
    deno
    b3sum
    telegram-desktop
    poetry
    dbeaver-bin
    postgresql
    yt-dlp_git
    android-tools
    unzip
    qdirstat
    usbutils
    jellyfin-desktop
    ffmpeg-full
    tutanota-desktop
    p7zip
    screen
    cargo-shear
    pandoc
    inkscape
    helix
    swaybg
    veracrypt
    libreoffice-fresh
    hunspell
    hunspellDicts.en_US
    hunspellDicts.it_IT
    obsidian
    libarchive
    vlc
    easyeffects
    pulseaudio
    iwgtk
    bruno
    xh
    jq
    tor-browser
    snapshot
    geeqie
    firefox-devedition
    weston-demos
    (pkgs.symlinkJoin {
      name = "sweethome3d";
      paths = [ pkgs.sweethome3d.application ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/sweethome3d \
          --set _JAVA_AWT_WM_NONREPARENTING 1
      '';
    })
    (vscode.override {
      commandLineArgs = [
        "--password-store=gnome-libsecret"
      ];
    })
  ];
}
