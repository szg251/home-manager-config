{ config, pkgs, ... }:

let
  secrets = import ./secrets.nix;
  ihp-new = builtins.fetchTarball {
    name = "ihp-new";
    url = "https://ihp.digitallyinduced.com/ihp-new.tar.gz";
    sha256 = "0xb6b5xdzblglgb5azbiy848m5wywsp02di2yn2zc6nmb456x52d";
  };
in {

  home.username = "gergo";
  home.homeDirectory = "/Users/gergo";

  home.stateVersion = "21.05";

  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "lambda";
      plugins = [ "git" "vi-mode" "fzf" ];
    };
    shellAliases = {
      oni = "/Applications/Onivim2.app/Contents/MacOS/Oni2";
      vim = "nvim";
      gitclean = ''
        git branch --merged | egrep -v "(^\*|master|develop|main)" | xargs git branch -d'';
    };
    sessionVariables = rec {
      NIX_IGNORE_SYMLINK_STORE = 1;
      EDITOR = "nvim";
      VISUAL = EDITOR;
      GIT_EDITOR = EDITOR;
      PATH = "$HOME/bin:/usr/local/bin:$HOME/mutable_node_modules/bin:$PATH";
      BITKEY_SERVICE_NPM_TOKEN = secrets.bitkeyServiceNpmToken;
    };
    initExtra = ''
      test -f ~/.nix-profile/etc/profile.d/nix.sh && source ~/.nix-profile/etc/profile.d/nix.sh
      test -f /etc/static/zshrc && source /etc/static/zshrc
      test -g "~/.iterm2_shell_integration.zsh" && source "~/.iterm2_shell_integration.zsh"
    '';
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    extraConfig = builtins.readFile ./home/vimConfig.vim;

    plugins = with pkgs.vimPlugins; [
      # General
      matchit-zip
      delimitMate
      coc-explorer

      vim-surround
      tabular
      vim-unimpaired
      fzf-vim
      ReplaceWithRegister
      vim-gitgutter
      vim-fugitive
      vim-commentary
      vim-rooter
      neoformat
      vim-repeat
      rnvimr

      # Looks
      gruvbox
      vim-airline

      # Language support
      vim-nix
      elm-vim
      haskell-vim
      coc-nvim
      coc-tsserver
      typescript-vim
      purescript-vim
      coc-json
      coc-prettier
      plantuml-syntax
    ];
  };

  programs.tmux = {
    enable = true;
    prefix = "C-b";
    keyMode = "vi";
    customPaneNavigationAndResize = true;
    terminal = "screen-256color";
    escapeTime = 10;
    baseIndex = 1;
    historyLimit = 500000;
    extraConfig = builtins.readFile ./home/tmuxConfig.conf;
    plugins = with pkgs.tmuxPlugins; [ battery ];
  };

  programs.git = {
    enable = true;
    userName = "Szabo Gergely";
    userEmail = "geg251@protonmail.com";
    extraConfig = {
      hub.protocol = "https";
      github.user = "gege251";
      color.ui = true;
      pull.rebase = false;
      merge.conflictstyle = "diff3";
      credential.helper = "osxkeychain";
      diff.algorithm = "patience";
      protocol.version = "2";
      core.commitGraph = true;
      gc.writeCommitGraph = true;
    };
  };

  programs.bat = {
    enable = true;
    config = { theme = "gruvbox"; };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableNixDirenvIntegration = true;
  };

  home.packages = with pkgs; [
    jq
    tree
    bash
    bash-completion
    unrar

    silver-searcher
    fzf
    ripgrep
    ranger

    # Cloud tools
    awscli
    amazon-ecs-cli
    google-cloud-sdk
    nodePackages.serverless
    # nodePackages.vercel

    # Dev tools
    gh
    circleci-cli
    gitlab-runner
    niv
    cachix
    newman
    plantuml

    ghc
    haskell-language-server
    cabal-install
    nodejs
    yarn
    nixfmt
    ormolu
    ihp-new
    nodePackages.node2nix
  ];
}
