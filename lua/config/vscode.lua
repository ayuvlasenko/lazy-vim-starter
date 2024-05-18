local map = vim.keymap.set
local opt = vim.opt

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

opt.clipboard = "unnamedplus"
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.wrapscan = true

-- useful mappings
map("n", "<C-j>", "i<CR><Esc>^", { desc = "Break a line" })

-- tabs navigation
map({ "n", "x" }, "<S-h>", ":tabprevious<CR>", { desc = "Prev tab" })
map({ "n", "x" }, "<S-l>", ":tabnext<CR>", { desc = "Next tab" })
map({ "n", "x" }, "<leader>c", ":tabclose<CR>", { desc = "Close tab" })

-- code navigation
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true })

-- windows navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- return to visual mode after indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- add bindings to accept copilot suggestions
map(
  "i",
  "<C-u>",
  [[<Cmd>lua require('vscode-neovim').call('editor.action.inlineSuggest.commit')<CR>]],
  { noremap = true, desc = "Accept Copilot suggestion" }
)
map(
  "i",
  "<C-a>",
  [[<Cmd>lua require('vscode-neovim').call('editor.action.inlineSuggest.acceptNextWord')<CR>]],
  { noremap = true, desc = "Accept next word from Copilot suggestion" }
)

-- other vscode bindings
map(
  "n",
  "<leader>e",
  [[<Cmd>lua require('vscode-neovim').call('workbench.view.explorer')<CR>]],
  { noremap = true, desc = "Open files explorer" }
)
