local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Check if lazy.nvim is already installed; if not, bootstrap it
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.updatetime = 200 -- Faster completion (default is 4000ms)
vim.opt.scrolloff = 8 -- Keep cursor away from screen edges

vim.opt.rtp:prepend(vim.env.LAZY or lazypath)
require("lazy").setup({
  ensure_installed = { "lua" }, -- Ensures "lua" is always installed
  highlight = { enable = true },
  spec = {
    -- LazyVim core plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    { import = "lazyvim.plugins.extras.coding.copilot" },
    -- Additional language support and UI enhancements
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.ui.mini-animate" },
    -- Custom plugins
    { import = "plugins" },
  },
  defaults = {
    lazy = false, -- Load custom plugins on startup by default
    version = false, -- Always use the latest commit for plugins
  },
  install = { colorscheme = { "tokyonight" } },
  checker = { enabled = true }, -- Automatically check for plugin updates
  performance = {
    filetypes = { exclude = { "markdown", "text" } },
    rtp = {
      disabled_plugins = {
        "gzip",
        -- Uncomment below to disable additional default plugins
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
