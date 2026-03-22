-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
---- Sửa lỗi hiển thị khi đang gõ tiếng Việt (Preedit)
vim.api.nvim_set_hl(0, "GuiuaPreedit", { bg = "NONE", fg = "NONE" })
-- Quan trọng: Một số bộ gõ dùng nhóm highlight 'Cursor' hoặc 'Underlined' cho chữ đang gõ
vim.api.nvim_set_hl(0, "InputMethod", { bg = "NONE", underline = true })
