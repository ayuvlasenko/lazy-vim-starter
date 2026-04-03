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
              includePackageJsonAutoImports = "on",
              importModuleSpecifierEnding = "minimal",
              autoImportFileExcludePatterns = { "apps/*/dist", "apps/*/build" },
            },
          },
          typescript = {
            tsserver = {
              maxTsServerMemory = 16184,
            },
            updateImportsOnFileMove = { enabled = "always" },
            preferences = {
              includePackageJsonAutoImports = "on",
              importModuleSpecifierEnding = "minimal",
              autoImportFileExcludePatterns = { "apps/*/dist", "apps/*/build" },
            },
          },
        },
      },
    },
    inlay_hints = { enabled = false },
  },
}
