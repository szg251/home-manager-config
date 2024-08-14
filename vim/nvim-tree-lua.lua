require 'nvim-tree'.setup {
  sync_root_with_cwd = true,
  respect_buf_cwd = true,
  actions = { open_file = { quit_on_open = true } },
  open_on_tab = true,
  disable_netrw = false,
  update_focused_file = {
    enable = true,
    update_root = true
  },
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
