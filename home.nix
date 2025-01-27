{ #config,
pkgs,inputs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "scott";
  home.homeDirectory = "/home/scott";

  home.packages = with pkgs; [
    #inputs.nixpkgs-stable.legacyPackages."x86_64-linux".btop
    alacritty
    btop
    cowsay
    direnv
    fish
    gimp
    helix
    htop
    inkscape-with-extensions
    lazygit
    stable.chromium
    stable.vim
    stable.zeroad
    tesseract
    tmux
    vscode
    wl-clipboard-rs
    zed-editor
    zellij
  ];

  programs.fish.enable = true;
  programs.firefox.enable = true;
  programs.git = {
    enable = true;
    userName = "brokenpike";
    userEmail = "brokenpike@garmr.org";
  };
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
