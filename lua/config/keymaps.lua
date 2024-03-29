vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll and center screen" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll and center screen" })
vim.keymap.set("n", "<C-j>", "i<CR><Esc>l", { desc = "Break a line" })
vim.keymap.set("n", "F8", function()
  vim.diagnostic.goto_next()
end, {
  desc = "Go to next diagnostic",
})
