-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "--depth=1",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

-- Initialize lazy.nvim
require("lazy").setup({
  spec = {
    -- LazyVim core
    {
      "LazyVim/LazyVim",
      import = "lazyvim.plugins",
    },
    -- Colorscheme
    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      opts = {
        style = "night",
      },
      init = function()
        vim.cmd.colorscheme("tokyonight-night")
      end,
    },

    -- Development tools
    { import = "lazyvim.plugins.extras.ai.copilot" },

    -- UI enhancements
    { import = "lazyvim.plugins.extras.ui.mini-animate" },

    -- Custom plugins (load last)
    { import = "plugins" },
  },

  defaults = {
    lazy = true,
    version = "*",
  },

  concurrency = 50,

  checker = {
    enabled = true,
    notify = true,
    frequency = 3600,
  },

  change_detection = {
    enabled = true,
    notify = false,
  },

  performance = {
    rtp = {
      reset = true,
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },

  ui = {
    size = { width = 0.8, height = 0.8 },
    border = "rounded",
  },
})
