-- bootstrap lazy.nvim, LazyVim and your plugins
local theme_mode = os.getenv("THEME_MODE") or "dark"
if theme_mode == "light" then
  vim.o.background = "light"
end
require("config.lazy")
