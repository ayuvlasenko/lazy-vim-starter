return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      graphql = {},
      vtsls = {
        settings = {
          javascript = {
            tsserver = {
              maxTsServerMemory = 16184,
            },
            updateImportsOnFileMove = { enabled = "always" },
            preferences = {
              autoImportFileExcludePatterns = { "**/dist/**", "**/build/**" },
            },
          },
          typescript = {
            tsserver = {
              maxTsServerMemory = 16184,
            },
            updateImportsOnFileMove = { enabled = "always" },
            preferences = {
              autoImportFileExcludePatterns = { "**/dist/**", "**/build/**" },
            },
          },
        },
      },
    },
    inlay_hints = { enabled = false },
  },
}
