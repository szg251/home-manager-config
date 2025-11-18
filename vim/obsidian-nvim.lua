local vimwiki_root = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/vimwiki";

require("obsidian").setup({
  workspaces = {
    {
      name = "personal",
      path = vimwiki_root,
    },
  },

  daily_notes = {
    folder = "diary",
  },

  legacy_commands = false,
})
