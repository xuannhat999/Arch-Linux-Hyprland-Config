-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    local clients = vim.lsp.get_active_clients()
    for _, client in ipairs(clients) do
      client.stop()
    end
  end,
})
