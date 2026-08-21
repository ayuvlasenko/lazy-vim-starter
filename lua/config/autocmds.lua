-- disable LazyVim's spell+wrap for markdown
vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  command = "setlocal tabstop=4 shiftwidth=4",
})

require("util.autosave").setup()

vim.treesitter.language.register("bash", "env")
vim.filetype.add({
  filename = {
    ["docker-compose.yaml"] = "yaml.docker-compose",
  },
})
