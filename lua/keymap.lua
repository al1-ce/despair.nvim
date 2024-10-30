-- All primary keymaps. Some plugin-related or screen-local might be in other files
local noremap = require("map").noremap
local remap = require("map").remap

local function info(msg) vim.notify(msg, vim.log.levels.info) end
local function error(msg) vim.notify(msg, vim.log.levels.error) end
local function warn(msg) vim.notify(msg, vim.log.levels.warn) end

-- tip: o switches vis direction

-- '' - normal, visual, select, operator pending
-- n - normal
-- v - visual and select
-- s - select
-- x - visual
-- o - operator pending
-- ! - insert and command line
-- i - insert
-- l - insert, command line and lang arg
-- c - command mode
-- t - terminal

-- map to <nop> to disable

-- Goal is to slowly move away from all those "normie" shortcuts

-- -------------------------------------------------------------------------- --
--                                   Global                                   --
-- -------------------------------------------------------------------------- --

-- ---------------------------- Common shortcuts ---------------------------- --

noremap('n', '<C-h>', 'b', { desc = "Goes back by word" })
noremap('n', '<C-l>', 'e', { desc = "Goes forward by word" })
noremap('n', '<C-left>', 'b', { desc = "Goes back by word" })
noremap('n', '<C-right>', 'e', { desc = "Goes forward by word" })

-- tab navigation
noremap("n", "<A-.>", "<cmd>tabnext<cr>", { desc = "Opens next tab" })
noremap("n", "<A-,>", "<cmd>tabprevious<cr>", { desc = "Opens previous tab" })

noremap("n", "<A-S-.>", "<cmd>tabmove +1<cr>", { desc = "Moves tab right" })
noremap("n", "<A-S-,>", "<cmd>tabmove -1<cr>", { desc = "Moves tab left" })

-- moving between panes
noremap("n", "<A-h>", "<C-w>h", { desc = "Focuses pane to the left" })
noremap("n", "<A-l>", "<C-w>l", { desc = "Focuses pane to the right" })
noremap("n", "<A-k>", "<C-w>k", { desc = "Focuses upper pane" })
noremap("n", "<A-j>", "<C-w>j", { desc = "Focuses lower pane" })
noremap("n", "<A-left>", "<C-w>h", { desc = "Focuses pane to the left" })
noremap("n", "<A-right>", "<C-w>l", { desc = "Focuses pane to the right" })
noremap("n", "<A-up>", "<C-w>k", { desc = "Focuses upper pane" })
noremap("n", "<A-down>", "<C-w>j", { desc = "Focuses lower pane" })

noremap("n", "<A-C-k>", "<C-w>-")
noremap("n", "<A-C-j>", "<C-w>+")
noremap("n", "<A-C-h>", "<C-w>>")
noremap("n", "<A-C-l>", "<C-w><")
noremap("n", "<A-C-up>", "<C-w>-")
noremap("n", "<A-C-down>", "<C-w>+")
noremap("n", "<A-C-left>", "<C-w>>")
noremap("n", "<A-C-right>", "<C-w><")

-- ctrl del
-- noremap("", "<C-Del>", '"_dw', { desc = "Delete in word forward" });
-- noremap("i", "<C-Del>", '<C-o>"_dw', { desc = "Delete in word forward" });

local function line_len(c_row)
    return #(vim.api.nvim_buf_get_lines(0, c_row, c_row + 1, false)[1])
end

local function delete_char(is_backspace)
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local c_row = cursor_pos[1] - 1
    local c_col = cursor_pos[2]
    local row_count = vim.api.nvim_buf_line_count(0)
    local col_count = line_len(c_row)
    -- vim.notify(vim.inspect(vim.api.nvim_buf_get_lines(0, c_row, c_row + 1, false)))

    if is_backspace == 1 then
        if c_row == 0 and c_col == 0 then return end
        if c_col == 0 then
            vim.api.nvim_buf_set_text(0, c_row - 1, line_len(c_row - 1), c_row, c_col, {})
        else
            vim.api.nvim_buf_set_text(0, c_row, c_col - 1, c_row, c_col, {})
        end
    else
        if c_row == row_count - 1 and c_col == col_count then return end
        if c_col == col_count then
            vim.api.nvim_buf_set_text(0, c_row, col_count, c_row + 1, 0, {})
        else
            vim.api.nvim_buf_set_text(0, c_row, c_col, c_row, c_col + 1, {})
        end
    end
    -- bs - start higher then end
    -- dle - invalid end_col: out of range
end

noremap("n", "<Del>", function() delete_char(0) end, { desc = "Delete but into black hole" })
noremap("i", "<Del>", function() delete_char(0) end, { desc = "Delete but into black hole" })
noremap("n", "<BS>", function() delete_char(1) end, { desc = "Deletes into black hole" });
noremap("i", "<BS>", function() delete_char(1) end, { desc = "Deletes into black hole" });

noremap('', '<S-ScrollWheelUp>', '3zh', { desc = "Scrolls right" })
noremap('', '<S-ScrollWheelDown>', '3zl', { desc = "Scrolls left" })
noremap('i', '<S-ScrollWheelUp>', '<C-o>3zh', { desc = "Scrolls right" })
noremap('i', '<S-ScrollWheelDown>', '<C-o>3zl', { desc = "Scrolls left" })

noremap('i', '<Esc>', '<Esc>l', { desc = "Makes insert exit at correct spot" });

local function lineHome()
    local x = vim.fn.col('.')
    vim.fn.execute('normal ^')
    if x == vim.fn.col('.') then
        vim.fn.execute('normal 0')
    end
end

local function lineEnd()
    local x = vim.fn.col('.')
    vim.fn.execute('normal g_')
    -- vim.fn.execute('normal! \\<Right>')
    vim.fn.execute("normal l")
    if x == vim.fn.col('.') then
        vim.fn.execute('normal g$')
    end
end

noremap('n', "<Home>", lineHome, { desc = "Goes to beginning of line" })
noremap('i', "<Home>", lineHome, { desc = "Goes to beginning of line" })
noremap('v', "<Home>", lineHome, { desc = "Goes to beginning of line" })
noremap('n', "<End>", lineEnd, { desc = "Goes to end of line" })
noremap('i', "<End>", lineEnd, { desc = "Goes to end of line" })
noremap('v', "<End>", lineEnd, { desc = "Goes to end of line" })

-- -------------------------------------------------------------------------- --
--                                 Normal Mode                                --
-- -------------------------------------------------------------------------- --

noremap("n", "<Tab>", ">>", { desc = "Shifts line to right" })
noremap("n", "<S-Tab>", "<<", { desc = "Shifts line to left" })
-- fix jump motion (thanks noremap)
noremap("n", "<C-i>", "<C-i>", { desc = "Jump motion fix" })

noremap("n", "<leader>ss", "<CMD>split<CR>", { desc = "[S]plit [S]horisontaly" })
noremap("n", "<leader>sv", "<CMD>vsplit<CR>", { desc = "[S]plit [V]ertically" })

noremap("n", "<leader>fs", "<C-^>", { desc = "[F]ile [S]wap" })
noremap("n", "<leader>fe", "<cmd>enew<cr>", { desc = "[F]ile [E]dit" })

noremap("n", "<leader>q", "<CMD>x<CR>", { desc = "[Q]uits buffer" })
noremap("n", "<leader>w", "<CMD>update<CR>", { desc = "[W]rites buffer" })

noremap("n", "<leader>cd", "<cmd>cd %:h<cr>", { desc = "[C]hanges [D]irectory to current file" })
noremap("n", "<leader>ce", "<cmd>edit $MYVIMRC <bar> tcd %:h<cr>", { desc = "[C]onfig [E]dit" })

noremap("n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "[T]ab [N]ew" })
noremap("n", "<leader>tw", "<cmd>tabclose<cr>", { desc = "[T]ab [C]lose" })
noremap("n", "<leader>to", "<cmd>tabonly<cr>", { desc = "[T]ab [O]nly" })

noremap("n", "<leader>fc", "<cmd>copen<cr>", { desc = "[F]ast [C]open" })
noremap("n", "<leader>fl", "<cmd>lopen<cr>", { desc = "[F]ast [L]open" })

local function fill_qf(lines, title, funcmod)
    vim.cmd("cexpr ['--" .. title .. "--']")
    vim.cmd("copen")
    for _, line in ipairs(lines) do
        if #line ~= 0 then
            if funcmod ~= nil then line = funcmod(line) end
            vim.cmd("caddexpr '" .. line:gsub("'", "''") .. "'")
        end
    end
    vim.fn.feedkeys("j")
end

local function fill_loc(lines, title, funcmod)
    vim.cmd("lexpr ['--" .. title .. "--']")
    vim.cmd("lopen")
    for _, line in ipairs(lines) do
        if #line ~= 0 then
            if funcmod ~= nil then line = funcmod(line) end
            vim.cmd("laddexpr '" .. line:gsub("'", "''") .. "'")
        end
    end
    vim.fn.feedkeys("j")
end

noremap("n", "<leader>ff", function()
    local i = vim.fn.input("File pattern: ")
    if #i == 0 then
        error("Must provide pattern"); return
    end
    local f = vim.system({ "bash", "-c", "rg --files . | rg -i '" .. i .. "'" }, { text = true }):wait()
    if #f.stdout == 0 then
        error("Failed to find " .. i)
    else
        local lines = vim.split(f.stdout, "\n")
        fill_loc(lines, "File Finder", function(l) return "filepath:" .. l end)
    end
    -- vim.print(f)
end, { desc = "[F]ind [F]iles" })

noremap("n", "<leader>fg", function()
    local i = vim.fn.input("Search pattern: ")
    if #i == 0 then
        error("Must provide pattern"); return
    end
    local f = vim.system({ "rg", "-i", "--no-heading", "--line-number", i },
        { text = true }):wait()
    -- vim.print(f)
    if f.code == 0 then
        local lines = vim.split(f.stdout, "\n")
        fill_loc(lines, "File Grep")
    else
        error("Failed to find pattern " .. i)
    end
end, { desc = "[F]ile [G]rep" })

noremap("n", "<leader>fr", function()
    fill_loc(vim.v.oldfiles, "Old Files", function(l) return 'filepath:' .. l end)
end, { desc = "[F]ind [R]ecent" })

noremap("n", "<leader>rg", function()
    local g = vim.fn.input("Grep pattern: ")
    if #g == 0 then
        error("No pattern supplied, aborting")
        return
    end
    local r = vim.fn.input("Replace pattern: ")
    local c = vim.fn.expand("%:p")
    local f = vim.system({ "rg", g, "--no-heading", "--line-number", "-r", r, c }, { text = true }):wait()
    -- info(vim.inspect(f))
    -- rg -F "from-pattern" -r "to-pattern" filename
    if f.code == 1 then
        error("Failed to find pattern " .. g)
        return
    end
    info(f.stdout)
    local yn = vim.fn.confirm("Do you want to apply changes?", "&Yes\n&No")
    if yn ~= 1 then return end
    local lines = vim.split(f.stdout, "\n")
    for _, line in ipairs(lines) do
        if #line ~= 0 then
            local _, e = line:find("%d+:")
            local l = line:sub(e + 1)
            local n = tonumber(line:sub(1, e - 1)) - 1
            -- vim.print(tostring(n) .. "--" .. l)
            vim.api.nvim_buf_set_lines(0, n, n + 1, false, { l })
            -- TODO: add visual replacement
        end
    end
end, { desc = "[R]ip[G]rep" })

noremap("n", "<leader>ft", function()
    local f = vim.system(
    { "rg", "--no-heading", "--type", "all", "--line-number", ".*(?:TODO|FIXME|TEMP|REFACTOR|REVIEW|HACK|BUG):.*" },
        { text = true }):wait()
    if #f.stdout == 0 then
        error("No todo's found")
    else
        local lines = vim.split(f.stdout, "\n")
        fill_loc(lines, "Todo List")
    end
    -- vim.print(f)
end, { desc = "[F]ind [T]odo" })

-- some netrw mappings
noremap("n", "-", ':Ex <bar> :sil! /<C-R>=expand("%:t")<CR><CR>')

noremap("n", "<leader>bd", function() vim.cmd("!just default") end)
noremap("n", "<leader>bD", function() vim.cmd("!just default") end)
noremap("n", "<leader>bb", function() vim.cmd("!just build") end)
noremap("n", "<leader>br", function() vim.cmd("!just run") end)
noremap("n", "<leader>bR", function() vim.cmd("!just release") end)
noremap("n", "<leader>bf", function() vim.cmd("!just file " .. vim.fn.expand("%:p")) end)
noremap("n", "<leader>bt", function() vim.cmd("!just tags") end)

noremap("n", "<leader>co", "<cmd>copen<cr>", { desc = "[C][O]pen" }) 
noremap("n", "<leader>lo", "<cmd>lopen<cr>", { desc = "[L][O]pen" }) 

-- noremap("n", "<leader>fF", vim.lsp.buf.format, { desc = "[F]ile [F]ormat" })
-- noremap("n", "<leader>lI", function ()
--     ---@diagnostic disable-next-line: missing-parameter
--     vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
--     ---@diagnostic disable-next-line: missing-parameter
--     if vim.lsp.inlay_hint.is_enabled() then
--         print("Enabled inlay hint")
--     else
--         print("Disabled inlay hint")
--     end
-- end, { desc = "[L]sp [I]nlay toggle" })

noremap("n", "<leader>t1", "1gt", { desc = "Go to [t]ab [1]" })
noremap("n", "<leader>t2", "2gt", { desc = "Go to [t]ab [2]" })
noremap("n", "<leader>t3", "3gt", { desc = "Go to [t]ab [3]" })
noremap("n", "<leader>t4", "4gt", { desc = "Go to [t]ab [4]" })
noremap("n", "<leader>t5", "5gt", { desc = "Go to [t]ab [5]" })
noremap("n", "<leader>t6", "6gt", { desc = "Go to [t]ab [6]" })
noremap("n", "<leader>t7", "7gt", { desc = "Go to [t]ab [7]" })
noremap("n", "<leader>t8", "8gt", { desc = "Go to [t]ab [8]" })
noremap("n", "<leader>t9", "9gt", { desc = "Go to [t]ab [9]" })
noremap("n", "<leader>t0", "<cmd>tablast<cr>", { desc = "Go to last tab" })


local function open_link_vis()
    vim.fn.feedkeys('"vy', "x")
    vim.fn.feedkeys(vim.keycode("<esc>"), "x")
    local s = vim.fn.getreg("v")
    vim.ui.open(vim.fn.expand(s))
    require("notify")(s)
end

local function open_link_norm()
    -- "x" makes it fast
    vim.fn.feedkeys("viW", "x")
    open_link_vis()
end

noremap("n", "gx", open_link_norm, { desc = "[G]oes into link with [X]DG-OPEN" })
noremap("v", "gx", open_link_vis, { desc = "[G]oes into link with [X]DG-OPEN" })

noremap("n", "yA", "<cmd>%y<cr>", { desc = "[Y]anks [A]ll file" })

noremap("n", "n", "nzzzv", { desc = "Keep search centered" })
noremap("n", "N", "Nzzzv", { desc = "Keep search centered" })

-- -------------------------------------------------------------------------- --
--                                 Insert Mode                                --
-- -------------------------------------------------------------------------- --

-- enter visual mode
-- why not, it does nothing so...
noremap("i", "<S-up>", "<C-o>v<up>", { desc = "Selects text in visual mode" })
noremap("i", "<S-down>", "<C-o>v<down>", { desc = "Selects text in visual mode" })
noremap("i", "<S-left>", "<C-o>v<left>", { desc = "Selects text in visual mode" })
noremap("i", "<S-right>", "<C-o>v<right>", { desc = "Selects text in visual mode" })

noremap("i", "<C-S-up>", "<C-o>v<C-up>", { desc = "Selects text in visual mode" })
noremap("i", "<C-S-down>", "<C-o>v<C-down>", { desc = "Selects text in visual mode" })
noremap("i", "<C-S-left>", "<C-o>v<C-left>", { desc = "Selects text in visual mode" })
noremap("i", "<C-S-right>", "<C-o>v<C-right>", { desc = "Selects text in visual mode" })

-- erase word
-- noremap("i", "<C-BS>", '<C-\\><C-o>"_db', { desc = "Deletes word backwards" })

-- Black magic:
noremap('i', '<A-S-up>', '<Esc>"myy`["mPi', { desc = "Duplicates line up" })
noremap('i', '<A-S-down>', '<Esc>"myy`]"mpi', { desc = "Duplicates line down" })

noremap('v', '<A-S-up>', '"mY`["mP`[V`]v', { desc = "Duplicates lines up" })
noremap('v', '<A-S-down>', '"mY`]"mp`[V`]v', { desc = "Duplicates lines down" })

-- erase one tab
noremap("i", "<S-Tab>", "<C-o><<", { desc = "Shifts line left" });

noremap("v", "<S-down>", "<down>", { desc = "Prevent buffer scroll" })
noremap("v", "<S-up>", "<up>", { desc = "Prevent buffer scroll" })

-- -------------------------------------------------------------------------- --
--                                 Visual Mode                                --
-- -------------------------------------------------------------------------- --

-- backspace
noremap("v", "<BS>", '"_X', { desc = "Deletes into black hole" });

-- move tabs
noremap("v", "<Tab>", ">`<V`>", { desc = "Shifts lines right" })
noremap("v", "<S-Tab>", "<`<V`>", { desc = "Shifts lines left" })

-- -------------------------------------------------------------------------- --
--                                Terminal Mode                               --
-- -------------------------------------------------------------------------- --

-- Use Esc to quit builtin terminal
noremap("t", "<Esc>", [[<c-\><c-n>]], { desc = "Exits terminal insert mode" })

-- -------------------------------------------------------------------------- --
--                               Custom Execute                               --
-- -------------------------------------------------------------------------- --

noremap("n", "<leader>xb", "yy2o<ESC>kpV:!/bin/bash<CR>", { desc = "[E]xecute [B]ash and paste" })
noremap("v", "<leader>xb", "y'<P'<O<ESC>'>o<ESC>:<C-u>'<,'>!/bin/bash<CR>", { desc = "[E]xecute [B]ash and paste" })

noremap("n", "<leader>xsl", "<cmd>vsplit /tmp/nvim-scratchpad.lua<cr><cmd>w<cr>", { desc = "E[x]ecute [S]cratch [L]ua" })

-- -------------------------------------------------------------------------- --
--                               Custom Command                               --
-- -------------------------------------------------------------------------- --

noremap("n", "<leader>ow", "<cmd>Wrap<cr>", { desc = "Toggle [O]ption - [W]rap" })
noremap("n", "<leader>os", "<cmd>Spell<cr>", { desc = "Toggle [O]ption - [S]pell" })
-- -------------------------------------------------------------------------- --
--                               Custom Textobj                               --
-- -------------------------------------------------------------------------- --

noremap("x", "il", "g_o^", { desc = "[I]n [L]ine text object" })
noremap("x", "al", "$o^", { desc = "[A]round [L]ine text object" })
noremap("o", "il", ":norm vil<cr>", { desc = "[I]n [L]ine text object" })
noremap("o", "al", ":norm val<cr>", { desc = "[A]round [L]ine text object" })

noremap("o", "g$", ":norm vg$h<cr>", { desc = "To end of line text object" })
noremap("o", "g_", ":norm vg_h<cr>", { desc = "To last char in line text object" })
noremap("o", "^", ":norm v^<cr>", { desc = "To first char in line text object" })
noremap("o", "0", ":norm v0<cr>", { desc = "To start of line text object" })
