-- vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll and center screen" })
-- vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll and center screen" })
vim.keymap.set("n", "<C-j>", "i<CR><Esc>^", { desc = "Break a line" })

vim.keymap.set("n", "<leader>cw", function()
  local word = vim.fn.expand("<cword>")
  local dict = vim.fn.expand("~/.config/cspell/custom-words.txt")
  local confirm = vim.fn.confirm("Add '" .. word .. "' to cspell dictionary?", "&Yes\n&No", 2)
  if confirm ~= 1 then
    return
  end
  local file = io.open(dict, "a")
  if file then
    file:write(word .. "\n")
    file:close()
    vim.notify("Added '" .. word .. "' to cspell dictionary", vim.log.levels.INFO)
    vim.cmd("e!")
    require("lint").try_lint()
  end
end, { desc = "Add word to cspell dictionary" })
