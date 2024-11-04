local bufnoremap = require("map").bufnoremap
local remap      = require("map").remap

bufnoremap("n", "<leader>xf", "<cmd>w<cr><cmd>source %<cr>", { desc = "E[X]ecute [F]ile" })

