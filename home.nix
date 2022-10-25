{ config, pkgs, ... }:

let
  ihp-new = builtins.fetchTarball {
    name = "ihp-new";
    url = "https://ihp.digitallyinduced.com/ihp-new.tar.gz";
  };
in
{
  home.username = "gergo";
  home.homeDirectory = "/Users/gergo";

  home.stateVersion = "21.11";

  programs.home-manager.enable = true;

  programs.kitty = {
    enable = true;
    font.name = "FuraCode NF";
    font.size = 14;
    keybindings = {
      "cmd+enter" = "launch --cwd=current";
      "cmd+i" = "previous_window";
      "cmd+o" = "next_window";
      "0x5d" = "\\u005c"; # Remap ¥ to \
    };
    settings = {
      tab_bar_style = "powerline";
      copy_on_select = true;
    };
    extraConfig = ''map 0x5d send_text all \u005c'';
  };

  programs.zsh = {
    enable = true;
    enableCompletion = false;
    oh-my-zsh = {
      enable = true;
      theme = "ys";
      plugins = [ "git" "vi-mode" "fzf" ]; # "vi-mode" 
    };
    shellAliases = {
      vimwiki = "nvim -c :VimwikiIndex";
      gitclean = ''
        git branch --merged | egrep -v "(^\*|master|develop|main)" | xargs git branch -d'';
      tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
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
      test -g "~/.iterm2_shell_integration.zsh" && source "~/.iterm2_shell_integration.zsh"

      precmd() {
        echo -ne "\e]1;$(pwd | sed 's/.*\///')\a"
      }
    '';
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    extraConfig = builtins.readFile ./home/vimConfig.vim;
    coc = {
      enable = true;
      pluginConfig = ''
        command! -nargs=0 Prettier :CocCommand prettier.formatFile

        " Make <CR> to accept selected completion item or notify coc.nvim to format
        " <C-g>u breaks current undo, please make your own choice.
        inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                                      \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
        " inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
        nnoremap <leader>d :call <SID>show_documentation()<CR>

        " GoTo code navigation.
        nmap <leader>cd <Plug>(coc-definition)
        nmap <leader>ct <Plug>(coc-type-definition)
        nmap <leader>ci <Plug>(coc-implementation)
        nmap <leader>cr <Plug>(coc-references)

        function! s:show_documentation()
          if (index(['vim','help'], &filetype) >= 0)
            execute 'h '.expand('<cword>')
          elseif (coc#rpc#ready())
            call CocActionAsync('doHover')
          else
            execute '!' . &keywordprg . " " . expand('<cword>')
          endif
        endfunction
      '';
      settings = builtins.fromJSON (builtins.readFile ./home/cocConfig.json);
    };

    plugins = with pkgs.vimPlugins; [
      # General
      vimwiki
      matchit-zip
      delimitMate
      nvim-web-devicons
      nvim-tree-lua

      vim-surround
      tabular
      vim-unimpaired
      fzf-vim
      ReplaceWithRegister
      unicode-vim
      # telescope-nvim
      # telescope-fzf-native-nvim
      # plenary-nvim

      nvim-terminal-lua
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
      (nvim-treesitter.withPlugins (plugins: [
        plugins.tree-sitter-haskell
        plugins.tree-sitter-nix
        plugins.tree-sitter-dot
      ]))
      Coqtail
      vim-nix
      elm-vim
      # haskell-vim
      coc-tsserver
      # coc-metals # Scala language server
      # coc-solargraph
      # coc-rust-analyzer
      typescript-vim
      purescript-vim
      coc-json
      coc-prettier
      dhall-vim
      wmgraphviz-vim
      vim-solidity
      # mkdx
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
      # core.pager = "delta";
      # interactive.diffFilter = "delta";
      # add.interactive.useBuiltin = "false";
      # delta.navigate = "true";
      # delta.light = "true";
      # diff.colorMoved = "default";
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
    # General CLI tools
    jq
    tree
    bash
    bash-completion
    unrar
    lastpass-cli
    tldr
    rates
    neofetch
    uchess

    # File management
    silver-searcher
    fzf
    ripgrep
    fd
    ranger
    delta

    # Cloud tools
    # awscli
    amazon-ecs-cli
    google-cloud-sdk
    # nodePackages.serverless
    # nodePackages.vercel

    # Git/CI
    gh
    # circleci-cli
    # gitlab-runner

    # Haskell
    ghc
    # cabal2nix
    # niv
    haskell-language-server
    haskellPackages.fourmolu
    haskellPackages.cabal-fmt
    haskellPackages.hoogle
    # ihp-new

    # PureScript
    purescript
    spago
    nodePackages.purescript-language-server

    # Rust
    cargo
    rustfmt
    rustc

    # Elm
    elmPackages.elm-language-server
    elmPackages.elm-format
    elmPackages.elm-test

    # Nix
    rnix-lsp
    nix-tree
    cabal-install
    nixpkgs-fmt
    nix-prefetch-git
    arion
    cachix

    # Dhall
    dhall

    # JS
    nodejs
    yarn
    # nodePackages.node2nix

    # Other dev tools
    ipfs
    latexrun
    graphviz
    pandoc
    librsvg
    texlive.combined.scheme-small
  ];
}
