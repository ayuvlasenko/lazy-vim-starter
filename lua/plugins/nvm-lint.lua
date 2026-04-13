return {
  "mfussenegger/nvim-lint",
  opts = {
    linters_by_ft = {
      ["*"] = { "cspell" },
      -- disable markdownlint-cli2 from markdown extra
      markdown = {},
    },
    -- linters = {
    --   ["markdownlint-cli2"] = {
    --     prepend_args = { "--config", vim.fn.expand("~/.markdownlint.jsonc"), "--" },
    --   },
    -- },
  },
}
