return {
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    lazy = false,
    priority = 1000,
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        -- Cấu hình của bạn ở đây
      })

      -- Đăng ký phím tắt thủ công bên trong config
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live Grep" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
      local wk = require("which-key")
      wk.add({
        { "<leader>f", group = "Find", icon = "" }, -- Icon cho cả nhóm phím tắt bắt đầu bằng <leader>f
        { "<leader>ff", icon = "" }, -- Icon riêng cho Find Files
        { "<leader>fg", icon = "" }, -- Icon riêng cho Live Grep
        { "<leader>fb", icon = "" }, -- Icon riêng cho Buffers
      })
    end,
  },
}
