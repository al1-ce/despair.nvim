local load = require("module").load

vim.g.mapleader = ";"

load('options')
load('filetypes')
load('keymap')
load('autocmd')
load('commands')

vim.cmd.colorscheme("gruvbox")

