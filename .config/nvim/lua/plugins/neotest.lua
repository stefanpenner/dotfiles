return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      -- plenary and treesitter are provided by LazyVim
      { "fredrikaverpil/neotest-golang", version = "*" },
    },
    opts = {
      adapters = {},
    },
    config = function(_, opts)
      opts.adapters = {
        require("neotest-golang"),
      }
      require("neotest").setup(opts)
    end,
  },
}
