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

map("n", "<C-j>", "i<CR><Esc>^", { desc = "Break a line" })
map(
  "n",
  "<leader>lr",
  [[<Cmd>lua require('vscode-neovim').call('editor.action.rename')<CR>]],
  { noremap = true, desc = "Rename" }
)

map({ "n", "x" }, "<S-h>", "gT", { desc = "Prev tab", remap = true })
map({ "n", "x" }, "<S-l>", "gt", { desc = "Next tab", remap = true })
map({ "n", "x" }, "<leader>c", "<C-w>c", { desc = "Close window", remap = true })
map({ "n", "x" }, "<leader>bd", "<C-w>c", { desc = "Close window", remap = true })
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true })

map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

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

map(
  "n",
  "<leader>e",
  [[<Cmd>lua require('vscode-neovim').call('workbench.view.explorer')<CR>]],
  { noremap = true, desc = "Open files explorer" }
)
