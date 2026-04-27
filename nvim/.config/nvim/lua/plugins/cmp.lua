-- plugins/cmp.lua
return {
  {
    "hrsh7th/nvim-cmp",
    lazy = true,
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.completion = {
        completeopt = "menu,menuone,noinsert",
      }
      opts.window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      }
      return opts
    end,
  },
}
