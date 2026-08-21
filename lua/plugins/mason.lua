return {
  "mason-org/mason.nvim",
  lazy = vim.env.NVIM_LIGHT == nil,
  opts = {
    ensure_installed = {
      "cspell",
      "js-debug-adapter",
    },
  },
}
