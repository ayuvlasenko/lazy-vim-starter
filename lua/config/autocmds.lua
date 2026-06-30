-- disable LazyVim's spell+wrap for markdown
vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
  command = "setlocal tabstop=4 shiftwidth=4",
})
vim.treesitter.language.register("bash", "dotenv")
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
    -- [".env"] = "dotenv",
    ["docker-compose.yaml"] = "yaml.docker-compose",
  },
  -- pattern = {
  --   ["%.env%.[%w_.-]+"] = "dotenv",
  -- },
})
