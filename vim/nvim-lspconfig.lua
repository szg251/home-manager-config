require("lsp-format").setup {}

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    require("lsp-format").on_attach(client, args.buf)
  end,
})

-- vim.lsp.config("aiken", {
--  {
--   default_config = {
--     cmd = { 'aiken', 'lsp' },
--     filetypes = { 'aiken' },
--     root_dir = function(fname)
--       return util.root_pattern('aiken.toml', '.git')(fname)
--     end,
--   },
--   docs = {
--     description = [[
-- https://github.com/aiken-lang/aiken

-- A language server for Aiken Programming Language.
-- [Installation](https://aiken-lang.org/installation-instructions)

-- It can be i
-- ]],
--     default_config = {
--       cmd = { 'aiken', 'lsp' },
--       root_dir = [[root_pattern("aiken.toml", ".git")]],
--     },
--   },
-- })


vim.lsp.enable({
  "ts_ls",
  "rust_analyzer",
  "taplo",
  "hls",
  "purescriptls",
  "nil_ls",
  "nixd",
  "dhall_lsp_server",
  "lua_ls",
  "elmls",
  "solidity_ls_nomicfoundation",
  "denols",
  "marksman",
  "jsonls",
  "html",
  "aiken",
  "postgres_lsp",
  "buf_ls",
  "pyright",
  "texlab",
  "gopls",
  "sourcekit",
})

vim.lsp.config("ts_ls", {
  root_dir = function(filename)
    local util = require 'lspconfig.util'
    if util.root_pattern("deno.json")(filename) then
      return nil -- Disable ts_ls inside Deno projects
    end
    return util.root_pattern("package.json", "tsconfig.json")(filename)
  end,

});




vim.lsp.config("rust_analyzer", {
  -- Server-specific settings...
  settings = {
    ["rust-analyzer"] = {
      check = {
        command = "clippy",
        features = "all"
      }
    }
  }
})
vim.lsp.config("hls", {
  settings = {
    haskell = {
      formattingProvider = "fourmolu",
      cabalFormattingProvider = "cabal-fmt"

    }
  }
})
vim.lsp.config("purescriptls", {
  settings = {
    purescript = {
      formatter = "purs-tidy"
    }
  }
})
-- Nix
vim.lsp.config("nil_ls", {
  settings = {
    ['nil'] = {
      formatting = {
        command = { "nixfmt" },
      },
      nix = {
        flake = {
          autoArchive = true,
        },
      }
    }
  }
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = {
        enable = false,
      },
    },
  },
})
