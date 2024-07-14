-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.foldmethod = "marker"
vim.opt.diffopt:append("vertical")
vim.opt.clipboard:append("unnamedplus")
vim.opt.modeline = true
vim.opt.wildignore:append({ "*.o", "*.a", "__pycache__" })
