{ pkgs, ... }:

{
  home.username = "gergo";
  home.homeDirectory = "/Users/gergo";

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;

  manual.manpages.enable = false;

  programs.zsh = {
    enable = true;
    enableCompletion = false;
    history = {
      extended = true;
      ignoreAllDups = true;
      ignoreDups = true;
      ignoreSpace = true;
      ignorePatterns = [ "ls*" "cd*" "exa*" "pwd*" "exit*" "cd*" ];
      share = true;
      save = 10000000;
      size = 10000000;
    };

    zplug = {
      enable = true;
      plugins = [
        { name = "jeffreytse/zsh-vi-mode"; }
      ];
    };

    shellAliases = {
      vimwiki = "nvim -c :VimwikiIndex";
      gitclean = ''
        git branch --merged | egrep -v "(^\*|master|develop|main)" | xargs git branch -d'';
      darwin-update = "$HOME/.config/nix-darwin/darwin-update.sh";
      tableplus = ''SSH_AUTH_SOCK="~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock" open -a /Applications/TablePlus.app'';
      kitty = "/Applications/kitty.app/Contents/MacOS/kitty";
      kitten = "/Applications/kitty.app/Contents/MacOS/kitten";
    };
    sessionVariables = rec {
      NIX_IGNORE_SYMLINK_STORE = 1;
      EDITOR = "nvim";
      VISUAL = EDITOR;
      GIT_EDITOR = EDITOR;
      PATH = "$HOME/bin:/usr/local/bin:$HOME/mutable_node_modules/bin:$PATH";
      DISABLE_AUTO_TITLE = "true";
    };
    initExtra = ''
      test -f ~/.nix-profile/etc/profile.d/nix.sh && source ~/.nix-profile/etc/profile.d/nix.sh
      test -f /etc/static/zshrc && source /etc/static/zshrc
      test -f ~/.config/op/plugins.sh && source ~/.config/op/plugins.sh

      precmd() {
        echo -ne "\e]1;$(pwd | sed 's/.*\///')\a"
      }
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd cd" ];
  };

  programs.neovim =
    {
      enable = true;
      vimAlias = true;
      extraConfig = builtins.readFile ./vim/init.vim;
      extraLuaConfig = builtins.readFile ./vim/init.lua;

      plugins =
        let
          withConfig = name:
            {
              plugin = pkgs.vimPlugins.${name};
              config = builtins.readFile ./vim/${name}.lua;
              type = "lua";
            };

        in
        with pkgs.vimPlugins;
        [
          # General
          (withConfig "vimwiki")
          matchit-zip
          # delimitMate
          (withConfig "nvim-autopairs")
          nvim-web-devicons
          (withConfig "nvim-tree-lua")
          (withConfig "nvim-lspconfig")
          lsp-status-nvim
          litee-nvim # GH-nvim dependency
          lsp-format-nvim
          # direnv-vim
          popfix # Dep of lsputils
          (withConfig "nvim-lsputils")
          (withConfig "inc-rename-nvim")

          # Autocompletion
          (withConfig "nvim-cmp")
          cmp-buffer
          cmp-path
          cmp-nvim-lsp
          cmp-nvim-lua

          vim-surround
          tabular
          vim-unimpaired
          ReplaceWithRegister
          unicode-vim
          telescope-nvim
          telescope-fzf-native-nvim
          plenary-nvim

          nvim-terminal-lua
          # vim-gitgutter
          (withConfig "gitsigns-nvim")
          conflict-marker-vim
          vim-fugitive
          vim-rhubarb

          vim-commentary
          (withConfig "vim-rooter")
          vim-repeat
          rnvimr
          neoformat

          # Looks
          awesome-vim-colorschemes
          vim-airline

          # Language support
          {
            plugin = (nvim-treesitter.withPlugins (plugins: [
              plugins.tree-sitter-haskell
              plugins.tree-sitter-c
              plugins.tree-sitter-cpp
              plugins.tree-sitter-nix
              plugins.tree-sitter-dot
              plugins.tree-sitter-rust
              plugins.tree-sitter-typescript
              plugins.tree-sitter-javascript
              plugins.tree-sitter-dockerfile
              plugins.tree-sitter-bash
              plugins.tree-sitter-elm
              plugins.tree-sitter-lua
              plugins.tree-sitter-sql
            ]));
            config = builtins.readFile ./vim/nvim-treesitter.lua;
            type = "lua";
          }
          # copilot-vim
          Coqtail
          vim-nix
          typescript-vim
          purescript-vim
          (withConfig "purescript-vim")
          dhall-vim
          wmgraphviz-vim
          vim-solidity
          vim-mustache-handlebars
          # (withConfig "mkdx")
          markdown-preview-nvim
          vim-markdown
          vimtex
        ];
    };

  programs.tmux = {
    enable = true;
    prefix = "C-b";
    keyMode = "vi";
    terminal = "screen-256color";
    escapeTime = 10;
    baseIndex = 1;
    historyLimit = 500000;
    extraConfig = builtins.readFile ./tmuxConfig.conf;
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
    signing = {
      signByDefault = true;
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP8SiZHctbdcQhuteXYuO1Yw4XgM/fO3QDTYKyyA4UKj";
    };
    difftastic.enable = true;
    extraConfig = {
      init.defaultBranch = "main";
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
      gpg.format = "ssh";
      gpg.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  home.packages = with pkgs; [
    # General CLI tools
    jq
    tree
    bash
    bash-completion
    mosh
    # unrar
    # lazygit
    # tldr
    tealdeer
    rates
    neofetch
    # uchess
    exercism
    cloc
    hci
    eza
    procs
    bottom
    starship

    # File management
    silver-searcher
    fzf
    ripgrep
    fd
    # ranger
    delta

    # Cloud tools
    # awscli
    # amazon-ecs-cli
    # google-cloud-sdk
    # nodePackages.serverless
    # nodePackages.vercel
    nixos-rebuild

    # Git/CI
    gh
    # circleci-cli
    # gitlab-runner

    # Haskell
    ghc
    # cabal2nix
    haskell-language-server
    haskellPackages.fourmolu
    haskellPackages.cabal-fmt
    # haskellPackages.hoogle
    # ihp-new

    # PureScript
    purescript
    # spago
    nodePackages.purescript-language-server

    # Rust
    cargo
    rustfmt
    rustc
    taplo
    cargo-expand

    # Elm
    elmPackages.elm-language-server
    elmPackages.elm-format
    elmPackages.elm-test

    # Nix
    nix-tree
    nix-melt
    cabal-install
    nixpkgs-fmt
    nix-prefetch-git
    cachix
    nil # Nix language server

    # Dhall
    dhall
    dhall-lsp-server

    # JS
    nodejs
    # yarn
    nodePackages.typescript-language-server
    # nodePackages.node2nix

    # lua
    lua
    lua-language-server

    # Other LSPs
    marksman # Markdown LSP
    nodePackages.vscode-langservers-extracted
    postgres-lsp
    pgformatter

    # Other dev tools
    # ipfs
    latexrun
    graphviz
    pandoc
    librsvg
    texlive.combined.scheme-small
    protobuf
    buf
    buf-language-server
  ];
}
