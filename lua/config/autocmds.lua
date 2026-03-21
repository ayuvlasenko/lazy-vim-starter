vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
  command = "setlocal tabstop=4 shiftwidth=4",
})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
  callback = function()
    LazyVim.lsp.action["source.organizeImports"]()
  end,
})
vim.filetype.add({
  -- extension = {
  --   foo = "fooscript",
  -- },
  -- filename = {
  --   ["Foofile"] = "fooscript",
  -- },
  -- pattern = {
  --   ["~/%.config/foo/.*"] = "fooscript",
  -- },
  filename = {
    [".env"] = "sh",
    ["docker-compose.yaml"] = "yaml.docker-compose",
  },
  pattern = {
    ["%.env%.[%w_.-]+"] = "sh",
  },
})
