require('setglobals')

vim.g.vim_distro = "despair.nvim"
vim.g.mapleader = ";"
vim.g.maplocalleader = ","

include 'options'
include 'filetypes'
include 'keymap'
include 'autocmd'
include 'commands'

local cs = require("colorscheme")
local st = require("statusline")

cs.source()
cs.on_reload(st.gen_hl_groups)
st.start_stline()

