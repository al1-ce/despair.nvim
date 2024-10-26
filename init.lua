local load = require("utils.loader")

vim.g.mapleader = ";"

load('config.options')
load('config.filetypes')
load('config.keymap')
load('config.autocmd')
load('config.commands')
load('config.intro')

vim.cmd.colorscheme("gruvbox")

