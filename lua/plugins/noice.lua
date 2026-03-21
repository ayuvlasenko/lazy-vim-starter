return {
  "folke/noice.nvim",
  opts = {
    routes = {
      {
        filter = {
          event = "notify",
          find = "does not support command.*didOrganizeImports",
        },
        opts = { skip = true },
      },
    },
  },
}
