local noremap = require("map").noremap

local function paste_file(fname)
    vim.cmd("-1 read " .. fname)
end

