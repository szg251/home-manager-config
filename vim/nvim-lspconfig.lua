local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}
local lspconfig = require("lspconfig")
local lsp_status = require("lsp-status")
local lsp_format = require("lsp-format")
local cmp_nvim_lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

local configs = require("lspconfig.configs")
local util = require 'lspconfig.util'

local aiken_lsp = {
  default_config = {
    cmd = { 'aiken', 'lsp' },
    filetypes = { 'aiken' },
    root_dir = function(fname)
      return util.root_pattern('aiken.toml', '.git')(fname)
    end,
  },
  docs = {
    description = [[
https://github.com/aiken-lang/aiken

A language server for Aiken Programming Language.
[Installation](https://aiken-lang.org/installation-instructions)

It can be i
]],
    default_config = {
      cmd = { 'aiken', 'lsp' },
      root_dir = [[root_pattern("aiken.toml", ".git")]],
    },
  },
}

if not configs.aiken then
  configs.aiken = aiken_lsp
end

lsp_format.setup {}

local on_attach = function(client, bufnr)
  lsp_status.on_attach(client, bufnr)
  lsp_format.on_attach(client)
end

local capabilities = vim.tbl_extend("keep",
  vim.lsp.protocol.make_client_capabilities(),
  cmp_nvim_lsp_capabilities,
  lsp_status.capabilities
);

lsp_status.register_progress()


lspconfig.ts_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = lsp_flags,
}
lspconfig.rust_analyzer.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = lsp_flags,
  -- Server-specific settings...
  settings = {
    ["rust-analyzer"] = { check = {
      command = "clippy",
      features = "all"
    } }
  }
}
lspconfig.taplo.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}
lspconfig.hls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = lsp_flags,
  settings = {
    haskell = {
      formattingProvider = "fourmolu"
    }
  }
}
lspconfig.purescriptls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    purescript = {
      formatter = "purs-tidy"
    }
  }
}
-- Nix
lspconfig.nil_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    ['nil'] = {
      formatting = {
        command = { "nixpkgs-fmt" },
      },
    },
  }
}
lspconfig.dhall_lsp_server.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}
lspconfig.lua_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}
lspconfig.elmls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}
lspconfig.marksman.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}
lspconfig.jsonls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}
lspconfig.html.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}
lspconfig.aiken.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}
lspconfig.postgres_lsp.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}
lspconfig.buf_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}
