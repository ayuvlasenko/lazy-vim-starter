-- vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll and center screen" })
-- vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll and center screen" })
vim.keymap.set("n", "<leader>J", "i<CR><Esc>^", { desc = "Split line" })

vim.keymap.set("n", "<leader>cw", function()
  local word = vim.fn.expand("<cword>")
  local dict = vim.fn.expand("~/.config/cspell/custom-words.txt")
  local file = io.open(dict, "a")
  if file then
    file:write(word .. "\n")
    file:close()
    vim.notify("Added '" .. word .. "' to cspell dictionary", vim.log.levels.INFO)
    require("lint").try_lint("cspell")
  end
end, { desc = "Add word to cspell dictionary" })
