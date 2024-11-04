local noremap = require("map").noremap

noremap("n", "<leader>bd", function() vim.cmd("!just default") end)
noremap("n", "<leader>bD", function() vim.cmd("!just debug") end)
noremap("n", "<leader>bb", function() vim.cmd("!just build") end)
noremap("n", "<leader>br", function() vim.cmd("!just run") end)
noremap("n", "<leader>bR", function() vim.cmd("!just release") end)
noremap("n", "<leader>bf", function() vim.cmd("!just file " .. vim.fn.expand("%:p")) end)
noremap("n", "<leader>bt", function() vim.cmd("!just tags") end)


