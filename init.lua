require('setglobals')

vim.g.vim_distro = "despair.nvim"
vim.g.mapleader = ";"
vim.g.maplocalleader = ","

include 'options'
include 'filetypes'
include 'keymap'
include 'autocmd'
include 'commands'

require("colorscheme").source()

