# config,
{
  pkgs,
  inputs,
  ...
}:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "scott";
  home.homeDirectory = "/home/scott";

  home.packages = with pkgs; [
    #inputs.nixpkgs-stable.legacyPackages."x86_64-linux".btop
    libreoffice-qt
    hunspell
    hunspellDicts.uk_UA
    hunspellDicts.th_TH
    hunspellDicts.nb-no
    languagetool
    alacritty
    signal-desktop-bin
    #signald
    btop
    cowsay
    direnv
    fish
    gimp
    htop
    inkscape-with-extensions
    lazygit
    stable.chromium
    stable.vim
    stable.zeroad
    tesseract
    tmux
    vscode
    # wl-clipboard-rs did not enable the hx system clipboard
    wl-clipboard
    zed-editor
    zellij
    nix-output-monitor
    tilix
  ];

  programs.helix = {
    enable = true;
    settings = {
      #theme = "autumn_night_transparent";
      theme = "everforest_light";
      editor.cursor-shape = {
        normal = "block";
        insert = "bar";
        select = "underline";
      };
    };
    languages.language = [
      {
        name = "nix";
        auto-format = true;
        formatter.command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
      }
    ];
    themes = {
      autumn_night_transparent = {
        "inherits" = "autumn_night";
        "ui.background" = { };
      };
    };
  };

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
