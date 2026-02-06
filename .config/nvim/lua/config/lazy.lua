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

-- -- Set essential options
-- vim.opt.updatetime = 200 -- Faster completion (default is 4000ms)
-- vim.opt.scrolloff = 8 -- Keep cursor away from screen edges
-- vim.opt.laststatus = 3 -- Global statusline
-- vim.opt.timeoutlen = 500 -- Time to wait for mapped sequence to complete
-- vim.opt.redrawtime = 1500 -- Time for syntax highlighting

-- Initialize lazy.nvim
require("lazy").setup({
  -- Core specs
  spec = {
    -- LazyVim core
    {
      "LazyVim/LazyVim",
      import = "lazyvim.plugins",
    },
    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      config = function()
        vim.cmd([[colorscheme tokyonight-night]])
      end,
    },

    -- Development tools
    { import = "lazyvim.plugins.extras.ai.copilot" },

    -- Language support
    -- Uncomment to enable
    -- { import = "lazyvim.plugins.extras.lang.typescript" },
    -- { import = "lazyvim.plugins.extras.lang.json" },

    -- Custom plugins (load last)
    { import = "plugins" },
  },

  -- Default configuration
  defaults = {
    lazy = true, -- Load plugins on demand
    version = "*", -- Use latest stable versions
    concurrency = 50, -- Max concurrent tasks
    install_missing = true, -- Install missing plugins on startup
  },

  -- Update checker
  checker = {
    enabled = false, -- Disabled for faster startup; run :Lazy check manually
  },

  -- Change detection
  change_detection = {
    enabled = true, -- Auto reload config on changes
    notify = false, -- Don't show notification on config changes
  },

  -- Performance optimizations
  performance = {
    -- cache = {
    --   enabled = true,
    -- },
    -- reset_packpath = true,      -- Reset packpath
    rtp = {
      reset = true, -- Reset rtp
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

  -- UI customization
  ui = {
    size = { width = 0.8, height = 0.8 }, -- Popup window size
    border = "rounded", -- Border style
    -- wrap = true,                        -- Uncomment if you want wrapped lines
  },
})
