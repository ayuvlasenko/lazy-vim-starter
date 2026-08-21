vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.scrolloff = 5
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.wrapscan = true
vim.opt.colorcolumn = "81"
vim.opt.belloff = "all"
vim.opt.title = true
vim.opt.titlestring = [[%{fnamemodify(getcwd(), ':t')}]]
vim.opt.diffopt:append("algorithm:histogram")

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
