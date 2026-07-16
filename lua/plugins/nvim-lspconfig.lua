return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      ["*"] = {
        keys = {
          { "<leader>co", false },
          {
            "<leader>ci",
            LazyVim.lsp.action["source.organizeImports"],
            desc = "Organize Imports",
            has = "codeAction",
            enabled = function(buf)
              local actions = vim.tbl_filter(function(action)
                return action:find("^source%.organizeImports%.?$")
              end, LazyVim.lsp.code_actions({ bufnr = buf }))
              return #actions > 0
            end,
          },
        },
      },
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
