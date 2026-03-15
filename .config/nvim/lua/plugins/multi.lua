return {
  {
    "mg979/vim-visual-multi",
    event = "VeryLazy",
  },

  -- Keep markdown rendering but disable linting/formatting
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        markdown = {},
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        markdown = {},
      },
    },
  },
}
