return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      prismals = {},
      vtsls = {
        settings = {
          javascript = {
            tsserver = {
              maxTsServerMemory = 16184,
            },
          },
          typescript = {
            tsserver = {
              maxTsServerMemory = 16184,
            },
          },
        },
      },
    },
    inlay_hints = { enabled = false },
  },
}
