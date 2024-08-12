local npairs = require("nvim-autopairs")
local Rule = require('nvim-autopairs.rule')

npairs.setup({
  check_ts = true,
})

local ts_conds = require('nvim-autopairs.ts-conds')
local cond = require('nvim-autopairs.conds')

npairs.add_rules({
  Rule("<", ">", "rust"):with_pair(cond.not_before_text(" ")),
  Rule("|", "|", "rust"):with_move(cond.done())
})
