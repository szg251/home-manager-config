set nocompatible
set number relativenumber
set tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab
set ai!
set foldmethod=syntax
setglobal foldlevelstart=99
set updatetime=300
set ignorecase
set smartcase
set hidden
set nobackup
set nowritebackup
set shortmess+=c
set signcolumn=yes
set cmdheight=2
set mouse=a
set clipboard=unnamed

syntax on
filetype plugin indent on


" Theme settings
colorscheme gruvbox 
let g:gruvbox_dark_contrast = 'hard'
set background=dark
set colorcolumn=100

" JS settings
let javaScript_fold=1

" Haskell settings
let g:haskell_conceal_wide = 1
let g:haskell_indent_if = 4
let g:haskell_indent_case = 4
let g:haskell_indent_let = 4
let g:haskell_indent_where = 6
let g:haskell_indent_before_where = 2
let g:haskell_indent_after_bare_where = 2
let g:haskell_indent_do = 3
let g:haskell_indent_in = 1
let g:haskell_indent_guard = 2
let g:haskell_indent_case_alternative = 1
let g:cabal_indent_section = 2

" elm-vim
let g:elm_setup_keybindings = 0

" WMGraphviz
let g:WMGraphviz_output = 'svg'

map <leader>mg :GraphvizShow<CR>

augroup graphviz
 autocmd!
 autocmd BufWritePost *.{dot} GraphvizCompile
augroup END

" Auto format
augroup fmt
 autocmd!
 autocmd BufWritePre *.{cabal,nix,purs,dhall} undojoin | Neoformat
augroup END

" FZF RG advanced
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

" Mkdx (markdown)
let g:mkdx#settings = { 'highlight': { 'enable': 1 },
                    \ 'enter': { 'shift': 1 },
                    \ 'links': { 'external': { 'enable': 1 } },
                    \ 'toc': { 'text': 'Table of Contents', 'update_on_write': 1 },
                    \ 'fold': { 'enable': 1 } }

""""""""""""""""""""""
" Keyboard Shortcuts "
"                    "
""""""""""""""""""""""
nnoremap <leader>s :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>h :noh<CR>
nnoremap <leader>gd :Gdiff!<CR>

" Substitute the word under the cursor.
" nmap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>

" FZF

nnoremap <Leader>p :Files<CR>
nnoremap <Leader>f :RG<CR>

" Telescope
" nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
" nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
" nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
" nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

" GitGutter
nmap ghs <Plug>(GitGutterStageHunk)
nmap ghu <Plug>(GitGutterUndoHunk)
nmap ghp <Plug>(GitGutterPreviewHunk)

nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)

" Fugitive
map <leader>b :GBrowse<CR>
map <leader>gs :G<CR>
map <leader>gl :diffget //2<CR>
map <leader>gr :diffget //3<CR>

" Markdown Preview
map <leader>mp :MarkdownPreviewToggle<CR>

" Nvim tree
lua <<EOF
require'nvim-tree'.setup {
  actions = { open_file = { quit_on_open = true } },
  open_on_tab = true,
  disable_netrw = false,
  update_focused_file = { enable = true },
  renderer = {
    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true
      }
    }
  }
}
EOF

nnoremap <leader>e :NvimTreeToggle<CR>

" " Treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
  -- ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
EOF


" VimWiki
" let g:vimwiki_list = [{'path': '~/Library/Mobile Documents/9CR7T2DMDG~com~ngocluu~onewriter/Documents/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]
" let g:vimwiki_list = [{'path': '~/Library/Mobile Documents/com~apple~CloudDocs/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]
let g:vimwiki_list = [{'path': '~/Documents/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]

let g:vimwiki_global_ext = 0
let g:vimwiki_listsyms =  ' .oOx'
let g:vimwiki_folding = 'expr'

" Coqtail
map <leader>cn :CoqNext<CR>
map <leader>ce :CoqUndo<CR>



set nocompatible
set number relativenumber
set tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab
set ai!
set foldmethod=syntax
setglobal foldlevelstart=99
set updatetime=300
set ignorecase
set smartcase
set hidden
set nobackup
set nowritebackup
set shortmess+=c
set signcolumn=yes
set cmdheight=2
set mouse=a
set clipboard=unnamed

syntax on
filetype plugin indent on


" Theme settings
colorscheme gruvbox 
let g:gruvbox_dark_contrast = 'hard'
set background=dark
set colorcolumn=100

" JS settings
let javaScript_fold=1

" Haskell settings
let g:haskell_conceal_wide = 1
let g:haskell_indent_if = 4
let g:haskell_indent_case = 4
let g:haskell_indent_let = 4
let g:haskell_indent_where = 6
let g:haskell_indent_before_where = 2
let g:haskell_indent_after_bare_where = 2
let g:haskell_indent_do = 3
let g:haskell_indent_in = 1
let g:haskell_indent_guard = 2
let g:haskell_indent_case_alternative = 1
let g:cabal_indent_section = 2

" elm-vim
let g:elm_setup_keybindings = 0

" WMGraphviz
let g:WMGraphviz_output = 'svg'

map <leader>mg :GraphvizShow<CR>

augroup graphviz
 autocmd!
 autocmd BufWritePost *.{dot} GraphvizCompile
augroup END

" Auto format
augroup fmt
 autocmd!
 autocmd BufWritePre *.{cabal,nix,purs,dhall} undojoin | Neoformat
augroup END

" FZF RG advanced
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

" Mkdx (markdown)
let g:mkdx#settings = { 'highlight': { 'enable': 1 },
                    \ 'enter': { 'shift': 1 },
                    \ 'links': { 'external': { 'enable': 1 } },
                    \ 'toc': { 'text': 'Table of Contents', 'update_on_write': 1 },
                    \ 'fold': { 'enable': 1 } }

""""""""""""""""""""""
" Keyboard Shortcuts "
"                    "
""""""""""""""""""""""
nnoremap <leader>s :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>h :noh<CR>
nnoremap <leader>gd :Gdiff!<CR>

" Substitute the word under the cursor.
" nmap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>

" FZF

nnoremap <Leader>p :Files<CR>
nnoremap <Leader>f :RG<CR>

" Telescope
" nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
" nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
" nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
" nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

" GitGutter
nmap ghs <Plug>(GitGutterStageHunk)
nmap ghu <Plug>(GitGutterUndoHunk)
nmap ghp <Plug>(GitGutterPreviewHunk)

nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)

" Fugitive
map <leader>b :GBrowse<CR>
map <leader>gs :G<CR>
map <leader>gl :diffget //2<CR>
map <leader>gr :diffget //3<CR>

" Markdown Preview
map <leader>mp :MarkdownPreviewToggle<CR>

" Nvim tree
lua <<EOF
require'nvim-tree'.setup {
  actions = { open_file = { quit_on_open = true } },
  open_on_tab = true,
  disable_netrw = false,
  update_focused_file = { enable = true },
  renderer = {
    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true
      }
    }
  }
}
EOF

nnoremap <leader>e :NvimTreeToggle<CR>

" " Treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
  -- ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
EOF


" VimWiki
" let g:vimwiki_list = [{'path': '~/Library/Mobile Documents/9CR7T2DMDG~com~ngocluu~onewriter/Documents/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]
" let g:vimwiki_list = [{'path': '~/Library/Mobile Documents/com~apple~CloudDocs/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]
let g:vimwiki_list = [{'path': '~/Documents/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]

let g:vimwiki_global_ext = 0
let g:vimwiki_listsyms =  ' .oOx'
let g:vimwiki_folding = 'expr'

" Coqtail
map <leader>cn :CoqNext<CR>
map <leader>ce :CoqUndo<CR>


" Vim Syntax file
" Language:       PGN
" Author:       Charles Ford <cford@eudoramail.com>
" pgn, or Portable Game Notation, is the standard
" notation for chess games.  Virtually all chess software
" read .pgn files, most can write .pgn files.

:syntax clear

:syntax case ignore

:syntax match pgnMove /[0-9]*\./
:syntax match pgnSymbol /[x\+]/
:syntax region pgnString start=/"/ end=/"/ contained
:syntax region pgnTag start=/\[/ end=/\]/ contains=pgnString
:syntax match pgnResult /[0-2]\/*[0-2]*[-][0-2]\/*[0-2]*/

:highlight link pgnTag Type
:highlight link pgnMove Comment
:highlight link pgnString Statement
:highlight link pgnSymbol Special
:highlight link pgnResult String


