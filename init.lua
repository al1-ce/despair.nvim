local load = require("module").load

vim.g.vim_distro = "despair.nvim"
vim.g.mapleader = ";"

load('options')
load('filetypes')
load('keymap')
load('autocmd')
load('commands')

vim.cmd.colorscheme("gruvbox")

