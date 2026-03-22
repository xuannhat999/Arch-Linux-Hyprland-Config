return {
  {
    "ravitemer/mcphub.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "MCPHub", "MCPServer" },
    build = "npm install -g mcp-hub@latest",
    config = function()
      require("mcphub").setup({
        port = 37373,
        -- Đường dẫn tuyệt đối đến file config JSON của bạn
        config = vim.fn.expand("~/.config/mcphub/servers.json"),
        extensions = {
          copilotchat = {
            enabled = true,
            convert_tools_to_functions = true,
            convert_resources_to_functions = true,
            add_mcp_prefix = false,
          },
        },
      })
    end,
  },
}
