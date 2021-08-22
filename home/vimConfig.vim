set nocompatible
set number relativenumber
set tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab
set ai!
set foldmethod=syntax
setglobal foldlevelstart=99
set updatetime=300
set ignorecase
set smartcase

" coc
set hidden
set nobackup
set nowritebackup
set shortmess+=c
set signcolumn=yes

set cmdheight=2

set mouse=a
set clipboard=unnamed


" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

syntax on
filetype plugin indent on


" Theme settings
colorscheme gruvbox 
let g:gruvbox_dark_contrast = 'hard'
set background=dark
set colorcolumn=100

" Python path settings (configured for MacPorts
" let g:python_host_prog = '$HOME/.nix-profile/bin/python'
" let g:python3_host_prog = '$HOME/.nix-profile/bin/python3'

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

augroup graphviz
 autocmd!
 autocmd BufWritePost *.{dot} GraphvizCompile
augroup END

" Ctrl P settings
" let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git\|elm-stuff'
" let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'


" let g:ctrlsf_winsize = '33%'
" let g:ctrlsf_auto_preview = 1
" let g:ctrlsf_auto_close = 0
" let g:ctrlsf_confirm_save = 0
" let g:ctrlsf_auto_focus = {
"     \ 'at': 'start',
"     \ }
" let g:ctrlsf_mapping = {
"     \ "next": "n",
"     \ "prev": "N",
"     \ }

" Auto format
augroup fmt
 autocmd!
 autocmd BufWritePre *.{cabal,nix} undojoin | Neoformat
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

" Coc Settings
command! -nargs=0 Prettier :CocCommand prettier.formatFile

""""""""""""""""""""""
" Keyboard Shortcuts "
"                    "
""""""""""""""""""""""

" Tmux Navigator
" nnoremap <silent>C-H :TmuxNavigateLeft<cr>
" nnoremap <silent>C-J :TmuxNavigateDown<cr>
" nnoremap <silent>C-K :TmuxNavigateUp<cr>
" nnoremap <silent>C-L :TmuxNavigateRight<cr>
" nnoremap <silent>C-\ :TmuxNavigatePrevious<cr>

" Substitute the word under the cursor.
nmap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>

" CoC

inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
nnoremap <leader>d :call <SID>show_documentation()<CR>

" GoTo code navigation.
nmap <leader>gd <Plug>(coc-definition)
nmap <leader>gy <Plug>(coc-type-definition)
nmap <leader>gi <Plug>(coc-implementation)
nmap <leader>gr <Plug>(coc-references)

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Coc Explorer
nnoremap <leader>e :CocCommand explorer<CR>

" FZF

nnoremap <Leader>p :Files<CR>
nnoremap <Leader>f :RG<CR>

" CtrlSF settings
" nmap <leader>a :CtrlSF -R ""<Left>
" nmap <leader>A <Plug>CtrlSFCwordPath -W<CR>
" nmap <leader>c :CtrlSFFocus<CR>
" nmap <leader>C :CtrlSFToggle<CR>

" GitGutter
nmap ghs <Plug>(GitGutterStageHunk)
nmap ghu <Plug>(GitGutterUndoHunk)
nmap ghp <Plug>(GitGutterPreviewHunk)

" Fugitive
map <leader>b :GBrowse<CR>
