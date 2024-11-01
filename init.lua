require('setglobals')

vim.g.vim_distro = "despair.nvim"
vim.g.mapleader = ";"
vim.g.maplocalleader = ","

include 'options'
include 'filetypes'
include 'keymap'
include 'autocmd'
include 'commands'

local st = require("statusline")
local cs = require("colorscheme")
cs.on_reload(st.gen_hl_groups)
st.start_stline()
cs.source()

