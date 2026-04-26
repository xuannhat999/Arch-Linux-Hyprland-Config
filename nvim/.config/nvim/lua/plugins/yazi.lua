return {
  ---@type LazySpec
  {
    "mikavilpas/yazi.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = {
      { "nvim-lua/plenary.nvim", lazy = true },
    },
    keys = {
      {
        "<leader>-",
        mode = { "n", "v" },
        "<cmd>Yazi cwd<cr>",
        desc = "Yazi",
      },
    },
    ---@type YaziConfig | {}
    opts = {
      open_for_directories = false,
      keymaps = {
        show_help = "<f1>",
      },
    },
  },
}
