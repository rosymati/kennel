pkgs: with pkgs; [
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
  claude-code
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
  opencode
  pnpm
  zen-browser
  deno
  b3sum
  telegram-desktop
  poetry
  dbeaver-bin
  postgresql
  yt-dlp
  android-tools
  pcsx2
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
  protonup-qt
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
]
