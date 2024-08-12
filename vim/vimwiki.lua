local vimwiki_root = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/vimwiki";

vim.g.vimwiki_list =
{ {
  path = vimwiki_root,
  syntax = "markdown",
  ext = ".md",
  auto_diary_index = 1,
} }
vim.g.vimwiki_global_ext = 0
vim.g.vimwiki_listsyms = " .oOx"
vim.g.vimwiki_folding = "expr"
