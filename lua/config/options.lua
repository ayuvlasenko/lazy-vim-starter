vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.spell = true
vim.opt.spelllang = { "en_us", "ru" }
vim.opt.spelloptions = "camel"
-- don't check for capital letters at start of sentence
vim.opt.spellcapcheck = ""
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.so = 5
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.wrapscan = true
vim.opt.colorcolumn = "81"
vim.opt.belloff = "all"
vim.opt.title = true
vim.opt.titlestring = [[%{fnamemodify(getcwd(), ':t')}]]

vim.g.mapleader = " "
