{ config, pkgs, ... }:

let
  secrets = import ./secrets.nix;
  ihp-new = builtins.fetchTarball {
    name = "ihp-new";
    url = "https://ihp.digitallyinduced.com/ihp-new.tar.gz";
  };
in {
  home.username = "gergo";
  home.homeDirectory = "/Users/gergo";

  home.stateVersion = "21.05";

  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = false;
    oh-my-zsh = {
      enable = true;
      theme = "lambda";
      plugins = [ "git" "vi-mode" "fzf" ];
    };
    shellAliases = {
      oni = "/Applications/Onivim2.app/Contents/MacOS/Oni2";
      md = "/Applications/Markdown Editor.app/Contents/MacOS/Markdown Editor";
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
    };
    initExtra = ''
      test -f ~/.nix-profile/etc/profile.d/nix.sh && source ~/.nix-profile/etc/profile.d/nix.sh
      test -f /etc/static/zshrc && source /etc/static/zshrc
      test -g "~/.iterm2_shell_integration.zsh" && source "~/.iterm2_shell_integration.zsh"

      # bear autocomplete setup
      BEAR_AC_ZSH_SETUP_PATH=/Users/gergo/Library/Caches/@sloansparger/bear/autocomplete/zsh_setup && test -f $BEAR_AC_ZSH_SETUP_PATH && source $BEAR_AC_ZSH_SETUP_PATH;
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
      # coc-explorer
      nvim-web-devicons
      nvim-tree-lua

      vim-surround
      tabular
      vim-unimpaired
      fzf-vim
      ReplaceWithRegister
      # telescope-nvim
      # telescope-fzf-native-nvim
      # plenary-nvim
      # nvim-treesitter

      vim-gitgutter
      vim-fugitive
      vim-rhubarb

      vim-commentary
      vim-rooter
      vim-repeat
      rnvimr
      neoformat

      # Looks
      awesome-vim-colorschemes
      vim-airline

      # Language support
      vim-nix
      elm-vim
      haskell-vim
      coc-nvim
      coc-tsserver
      coc-metals # Scala language server
      coc-solargraph
      coc-rust-analyzer
      typescript-vim
      purescript-vim
      coc-json
      coc-prettier
      wmgraphviz-vim
      vim-solidity
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
    plugins = [{
      plugin = pkgs.tmuxPlugins.battery;
      extraConfig = ''
        set -g @batt_icon_status_charged '+'
        set -g @batt_icon_status_charging '+'
        set -g @batt_icon_status_attached '±'
        set -g @batt_icon_status_discharging '-'
        set-option -g status-right "#{battery_percentage} #{battery_icon_status} #{battery_icon_charge}  %a %d %b %H:%M "
      '';
    }];
  };

  programs.git = {
    enable = true;
    userName = "Szabo Gergely";
    userEmail = "gege251@mailbox.org";
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
      push.default = "current";
    };
  };

  programs.bat = {
    enable = true;
    config = { theme = "gruvbox-dark"; };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  home.packages = with pkgs; [
    jq
    tree
    bash
    bash-completion
    unrar
    nix-tree
    nix-prefetch-git

    silver-searcher
    fzf
    ripgrep
    fd
    ranger

    # Cloud tools
    awscli
    amazon-ecs-cli
    google-cloud-sdk
    nodePackages.serverless
    # nodePackages.vercel
    ipfs

    # Dev tools
    gh
    circleci-cli
    gitlab-runner
    niv
    cachix
    cabal2nix
    ghc
    haskell-language-server
    elmPackages.elm-language-server
    elmPackages.elm-format
    elmPackages.elm-test
    rnix-lsp
    cabal-install
    nodejs
    yarn
    nixfmt
    ormolu
    haskellPackages.fourmolu
    haskellPackages.cabal-fmt
    haskellPackages.hoogle
    ihp-new
    nodePackages.node2nix
  ];
}
