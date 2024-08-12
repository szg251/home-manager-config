vim.o.compatible = false
vim.o.backup = false
vim.o.writebackup = false
vim.o.number = true
vim.o.relativenumber = true
vim.o.autoindent = true

vim.o.tabstop = 2
vim.o.softtabstop = 0
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.smarttab = true

vim.o.foldmethod = "syntax"
vim.o.foldlevel = 4
vim.go.foldlevelstart = 99

vim.o.updatetime = 300
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hidden = true
vim.o.signcolumn = "yes"
vim.o.cmdheight = 2
vim.o.mouse = "a"
vim.o.clipboard = "unnamed"
vim.o.title = true
vim.o.titlestring = "vim%=%<%F%m%r"
vim.o.titlelen = 70
vim.opt.shortmess:append("c")

-- Theme
vim.cmd [[syntax on]]
vim.cmd [[colorscheme happy_hacking]]
vim.o.background = "dark"
vim.g.gruvbox_dark_contrast = "hard"
vim.o.colorcolumn = 100

vim.g["WMGraphviz_output"] = "svg"

-- Key map
local normal_mode_keys = {
  ["<leader>s"] = ":w<CR>",
  ["<leader>q"] = ":q<CR>",
  ["<leader>h"] = ":noh<CR>",
  ["<leader>mg"] = ":GraphvizShow<CR>",
  ["<leader>e"] = ":NvimTreeToggle<CR>",
  -- Coq
  ["<leader>cn"] = ":CoqNext<CR>",
  ["<leader>ce"] = ":CoqUndo<CR>",
  -- GitGutter
  ["ghs"] = "<Plug>(GitGutterStageHunk)",
  ["ghu"] = "<Plug>(GitGutterUndoHunk)",
  ["ghp"] = "<Plug>(GitGutterPreviewHunk)",
  ["]h"] = "<Plug>(GitGutterNextHunk)",
  ["[h"] = "<Plug>(GitGutterPrevHunk)",
  -- LazyGit
  ["<leader>lg"] = ":LazyGit<CR>",
  -- Fugitive
  ["<leader>b"] = ":GBrowse<CR>",
  ["<leader>gd"] = ":Gdiff!<CR>",
  ["<leader>gs"] = ":G<CR>",
  ["<leader>gl"] = ":diffget //2<CR>",
  ["<leader>gr"] = ":diffget //3<CR>",
  --Markdown
  ["<leader>mp"] = ":MarkdownPreviewToggle<CR>",
  -- Telescope
  ["<leader>ff"] = require('telescope.builtin').find_files,
  ["<leader>fg"] = require('telescope.builtin').live_grep,
  ["<leader>fb"] = require('telescope.builtin').buffers,
  ["<leader>fh"] = require('telescope.builtin').help_tags,
  -- LSP
  ["<space>e"] = vim.diagnostic.open_float,
  ["[d"] = vim.diagnostic.goto_prev,
  ["]d"] = vim.diagnostic.goto_next,
  ["<space>q"] = vim.diagnostic.setloclist,
  ["gD"] = vim.lsp.buf.declaration,
  ["gd"] = vim.lsp.buf.definition,
  ["K"] = vim.lsp.buf.hover,
  ["gi"] = vim.lsp.buf.implementation,
  ["<C-k>"] = vim.lsp.buf.signature_help,
  ["<space>wa"] = vim.lsp.buf.add_workspace_folder,
  ["<space>wr"] = vim.lsp.buf.remove_workspace_folder,
  ["<space>wl"] = function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end,
  ["<space>D"] = vim.lsp.buf.type_definition,
  ["<space>rn"] = vim.lsp.buf.rename,
  ["<space>ca"] = vim.lsp.buf.code_action,
  ["gr"] = vim.lsp.buf.references,
  ["<space>f"] = function() vim.lsp.buf.format { async = true } end,
}

local visual_mode_keys = {
  ["<leader>b"] = ":GBrowse<CR>",
}
vim.keymap.set("n", "<leader>rn", function()
  return ":IncRename " .. vim.fn.expand("<cword>")
end, { expr = true })
-- Substitute the word under the cursor.
-- nmap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>

-----------------
-- Apply keymapping
-----------------

for k, c in pairs(normal_mode_keys)
do
  vim.keymap.set("n", k, c, { noremap = true })
end

for k, c in pairs(visual_mode_keys)
do
  vim.keymap.set("v", k, c, { noremap = true })
end


-----------------
-- Auto commands
-----------------
local graphvizFormat = vim.api.nvim_create_augroup("graphvizFormat", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.dot",
  command = "GraphvizCompile",
  group = graphvizFormat,
})

local cabalFormat = vim.api.nvim_create_augroup("cabalFormat", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.cabal" },
  command = "Neoformat",
  group = cabalFormat
})

local markdownSpellcheck = vim.api.nvim_create_augroup("markdownSpellcheck", { clear = true })
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.md" },
  command = "setlocal spell",
  group = markdownSpellcheck,
})