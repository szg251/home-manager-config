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
