{ pkgs, ... }:
let
  usersDir = if pkgs.stdenv.isDarwin then "/Users" else "/home";
in

{
  home.username = "gergo";
  home.homeDirectory = "${usersDir}/gergo";

  home.stateVersion = "25.05";

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
      ignorePatterns = [
        "ls*"
        "cd*"
        "exa*"
        "pwd*"
        "exit*"
        "cd*"
      ];
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
      gitclean = ''git branch --merged | egrep -v "(^\*|master|develop|main)" | xargs git branch -d'';
      darwin-update = "$HOME/.config/nix-darwin/darwin-update.sh";
      tableplus = ''SSH_AUTH_SOCK="~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock" open -a /Applications/TablePlus.app'';
      kitty = "/Applications/kitty.app/Contents/MacOS/kitty";
      ghostty = "/Applications/Ghostty.app/Contents/MacOS/ghostty";
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
    initContent = ''
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

  programs.neovim = {
    enable = true;
    vimAlias = true;
    extraLuaConfig = builtins.readFile ./vim/init.lua;

    plugins =
      let
        withConfig = name: {
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
        (withConfig "outline-nvim")
        (withConfig "nvim-lspconfig")
        litee-nvim # GH-nvim dependency
        lsp-format-nvim
        # direnv-vim
        (withConfig "inc-rename-nvim")
        camelcasemotion
        nvim-treesitter-context

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
        (withConfig "telescope-nvim")
        telescope-fzf-native-nvim
        telescope-ui-select-nvim
        trouble-nvim
        plenary-nvim

        nvim-terminal-lua
        # vim-gitgutter
        (withConfig "gitsigns-nvim")
        conflict-marker-vim
        vim-fugitive
        vim-rhubarb
        # gh-nvim # only in unstable atm

        vim-commentary
        # (withConfig "vim-rooter")
        (withConfig "project-nvim")
        vim-repeat
        rnvimr

        # Looks
        awesome-vim-colorschemes
        vim-airline

        # Language support
        {
          plugin = (
            nvim-treesitter.withPlugins (plugins: [
              plugins.tree-sitter-haskell
              plugins.tree-sitter-c
              plugins.tree-sitter-cpp
              plugins.tree-sitter-nix
              plugins.tree-sitter-dot
              plugins.tree-sitter-rust
              plugins.tree-sitter-python
              plugins.tree-sitter-typescript
              plugins.tree-sitter-javascript
              plugins.tree-sitter-dockerfile
              plugins.tree-sitter-bash
              plugins.tree-sitter-elm
              plugins.tree-sitter-lua
              plugins.tree-sitter-sql
              plugins.tree-sitter-go
            ])
          );
          config = builtins.readFile ./vim/nvim-treesitter.lua;
          type = "lua";
        }
        aiken-vim
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

  # programs.tmux = {
  #   enable = true;
  #   prefix = "C-b";
  #   keyMode = "vi";
  #   terminal = "screen-256color";
  #   escapeTime = 10;
  #   baseIndex = 1;
  #   historyLimit = 500000;
  #   extraConfig = builtins.readFile ./tmuxConfig.conf;
  #   plugins = [{
  #     plugin = pkgs.tmuxPlugins.battery;
  #     extraConfig = ''
  #       set -g @batt_icon_status_charged '+'
  #       set -g @batt_icon_status_charging '+'
  #       set -g @batt_icon_status_attached '±'
  #       set -g @batt_icon_status_discharging '-'
  #       set-option -g status-right "#{battery_percentage} #{battery_icon_status} #{battery_icon_charge}  %a %d %b %H:%M "
  #     '';
  #   }];
  # };

  programs.git =
    let
      commonConfig = {
        enable = true;
        userName = "Szabo Gergely";
        userEmail = "gege251@mailbox.org";
        signing.signByDefault = true;
        difftastic.enable = true;
        extraConfig = {
          init.defaultBranch = "main";
          hub.protocol = "https";
          github.user = "szg251";
          color.ui = true;
          pull.rebase = false;
          merge.conflictstyle = "diff3";
          diff.algorithm = "patience";
          protocol.version = "2";
          core.commitGraph = true;
          gc.writeCommitGraph = true;
          push.default = "current";
          push.autoSetupRemote = true;
          gpg.format = "ssh";
        };
      };
    in
    if pkgs.stdenv.isDarwin then
      commonConfig
      // {
        signing = {
          key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP8SiZHctbdcQhuteXYuO1Yw4XgM/fO3QDTYKyyA4UKj";
        };
        extraConfig = commonConfig.extraConfig // {
          credential.helper = "osxkeychain";
          gpg.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
        };
      }
    else
      commonConfig
      // {
        signing = {
          key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDgiQUve2sKgpGEnkoT8XpEulDMIs78k+sbpO3Vs5HIW";
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
    lima
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
    bat
    devenv

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
    pretty-simple
    ghc
    # cabal2nix
    (haskell-language-server.override { supportedGhcVersions = [ "912" ]; })
    # haskell-language-server
    fourmolu
    haskellPackages.cabal-fmt
    # haskellPackages.hoogle
    # ihp-new

    # PureScript
    # purescript
    # spago
    # nodePackages.purescript-language-server

    # Python
    pyright
    python313Packages.autopep8

    # Rust
    cargo
    rustfmt
    rustc
    taplo
    cargo-expand
    cargo-edit
    cargo-generate

    # Elm
    # elmPackages.elm-language-server
    # elmPackages.elm-format
    # elmPackages.elm-test

    # Nix
    nix-tree
    nix-melt
    nix-du
    cabal-install
    nixfmt-rfc-style
    nix-prefetch-git
    cachix
    nil # Nix language server
    nixd # Nix language server

    # Dhall
    # dhall
    dhall-lsp-server

    # JS
    nodejs
    # yarn
    nodePackages.typescript-language-server
    # nodePackages.eslint
    # nodePackages.node2nix
    nodePackages.prettier

    # Golang
    gopls

    # lua
    lua
    lua-language-server

    # Other LSPs
    marksman # Markdown LSP
    nodePackages.vscode-langservers-extracted
    postgres-lsp
    pgformatter

    # Swift
    sourcekit-lsp

    # Other dev tools
    # ipfs
    latexrun
    graphviz
    pandoc
    librsvg
    texlive.combined.scheme-small
    texlab
    protobuf
    buf
  ];
}
