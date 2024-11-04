---@diagnostic disable: lowercase-global
-- All primary keymaps. Some plugin-related or screen-local might be in other files
local noremap = require("map").noremap

-- local function info(msg)  vim.notify(msg, vim.log.levels.info) end
-- local function error(msg) vim.notify(msg, vim.log.levels.error) end
-- local function warn(msg)  vim.notify(msg, vim.log.levels.warn) end

local function paste_file(fname)
    vim.cmd("-1 read " .. fname)
end

-- some netrw mappings
noremap("n", "-", ':Ex <bar> :sil! /<C-R>=expand("%:t")<CR><CR>')

noremap("n", "<leader>bd", function() vim.cmd("!just default") end)
noremap("n", "<leader>bD", function() vim.cmd("!just debug") end)
noremap("n", "<leader>bb", function() vim.cmd("!just build") end)
noremap("n", "<leader>br", function() vim.cmd("!just run") end)
noremap("n", "<leader>bR", function() vim.cmd("!just release") end)
noremap("n", "<leader>bf", function() vim.cmd("!just file " .. vim.fn.expand("%:p")) end)
noremap("n", "<leader>bt", function() vim.cmd("!just tags") end)

noremap("n", "ys", [["v" . input("Where: ") . "\"sc" . input("Add what: ") . "<c-o>h<c-r>s<esc>"]], { expr=true })
noremap("n", "cs", [["vi" . input("Change what: ") . "\"sc<c-o>l<c-h><c-h>" . input("To what: ") . "<c-o>h<c-r>s<esc>"]], { expr=true })

-- neovim being beatcsh
-- can't just <esc>xx|dw
-- need to <esc><cr>gv:norm
-- whyyyyyyyyyyyyy
-- :normal f=50i 20|dw
noremap("v", "ga", [[":normal " . input("What to align (motion): ") . "256i <esc><cr>gv:norm" . input("Column to align to: ") . "|dw<cr>"]], { expr=true })

-- in ftplugin c
__switch_c_hc = function(split_type)
    local flipname
    if vim.fn.match(vim.fn.expand("%"), "\\.c") > 0 then
        flipname = vim.fn.substitute(vim.fn.expand("%:t"), "\\.c\\(.*\\)", ".h\\1", "")
    elseif vim.fn.match(vim.fn.expand("%"), "\\.h") > 0 then
        flipname = vim.fn.substitute(vim.fn.expand("%:t"), "\\.h\\(.*\\)", ".c\\1", "")
    else return end
    local ok, err = pcall(vim.cmd, "find " .. flipname)
    if not ok then
        vim.notify("Failed to find '" .. flipname .. "' in path.", vim.log.levels.ERROR)
    end
    if split_type ~= "none" then vim.cmd(split_type .. " | wincmd p | edit # | wincmd p") end
end

noremap("i", "<A-k>", "<esc>ddkPi", { desc = "Moves line up" })
noremap("i", "<A-j>", "<esc>ddpi", { desc = "Moves line down" })
noremap("i", "<A-up>", "<esc>ddkPi", { desc = "Moves line up" })
noremap("i", "<A-down>", "<esc>ddpi", { desc = "Moves line down" })

noremap("v", "<A-j>", [['xp`[' . getregtype()[0] . '`]']],    { desc = "Moves visual lines down", expr = true })
noremap("v", "<A-up>", [['xkP`[' . getregtype()[0] . '`]']],  { desc = "Moves visual lines up", expr = true })
noremap("v", "<A-down>", [['xp`[' . getregtype()[0] . '`]']], { desc = "Moves visual lines down", expr = true })
noremap("v", "<A-k>", [['xkP`[' . getregtype()[0] . '`]']],   { desc = "Moves visual lines up", expr = true })

noremap("n", "<leader>j", function()
    local buffers = vim.api.nvim_exec2("ls", { output = true} )
    if vim.fn.count(buffers.output, "\n") < 1 then
        vim.print("Found only a single buffer")
        return
    end
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<cr>", true, false, true), "n", {})
    vim.api.nvim_echo({{buffers.output}}, false, {})
    local inp = vim.fn.input("Enter buffer number: ")
    if inp == "" then return end
    local bufnr = tonumber(inp)
    if type(bufnr) ~= "number" then
        vim.notify("Must enter a number", vim.log.levels.error)
        return
    end
    vim.cmd("b " .. tostring(bufnr))
end, { desc = "Open buffer picker" })

-- command! Qbuffers call setqflist(map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), '{"bufnr":v:val}')) | copen


