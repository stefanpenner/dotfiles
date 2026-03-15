return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      { "fredrikaverpil/neotest-golang", version = "*" },
    },
    opts = {
      adapters = {
        ["neotest-golang"] = {},
      },
    },
  },
}
