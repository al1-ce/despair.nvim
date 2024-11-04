require('setglobals')

vim.g.vim_distro = "despair.nvim"
vim.g.mapleader = ";"
vim.g.maplocalleader = ","

include 'options'
include 'keymap'

require("colorscheme").source()

