-- All primary keymaps. Some plugin-related or screen-local might be in other files
local noremap = require("map").noremap

local function info(msg) vim.notify(msg, vim.log.levels.info) end
local function error(msg) vim.notify(msg, vim.log.levels.error) end
local function warn(msg) vim.notify(msg, vim.log.levels.warn) end

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

noremap("n", "ys", [["v" . input("Where: ") . "\"sc" . input("Add what: ") . "<c-o>h<c-r>s<esc>"]], { expr=true })
noremap("n", "cs", [["vi" . input("Change what: ") . "\"sc<c-o>l<c-h><c-h>" . input("To what: ") . "<c-o>h<c-r>s<esc>"]], { expr=true })

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

-- vim.cmd([[
--     function! Switch_To_Header_Source()
--         if match(expand("%"),'\.c') > 0
--             let s:flipname = substitute(expand("%:t"),'\.c\(.*\)','.h\1',"")
--             echo s:flipname
--             exe ":find " s:flipname
--         elseif match(expand("%"),"\\.h") > 0
--             let s:flipname = substitute(expand("%:t"),'\.h\(.*\)','.c\1',"")
--             exe ":find " s:flipname
--         endif
--     endfun
--     function! Switch_To_Header_Source_SP()
--         if match(expand("%"),'\.c') > 0
--             let s:flipname = substitute(expand("%:t"),'\.c\(.*\)','.h\1',"")
--             exe ":find " s:flipname
--             split
--             wincmd p
--             edit #
--             wincmd p
--         elseif match(expand("%"),"\\.h") > 0
--             let s:flipname = substitute(expand("%:t"),'\.h\(.*\)','.c\1',"")
--             exe ":find " s:flipname
--             split
--             wincmd p
--             edit #
--             wincmd p
--         endif
--     endfun
--     function! Switch_To_Header_Source_VSP()
--         if match(expand("%"),'\.c') > 0
--             let s:flipname = substitute(expand("%:t"),'\.c\(.*\)','.h\1',"")
--             exe ":find " s:flipname
--             vsplit
--             wincmd p
--             edit #
--             wincmd p
--         elseif match(expand("%"),"\\.h") > 0
--             let s:flipname = substitute(expand("%:t"),'\.h\(.*\)','.c\1',"")
--             exe ":find " s:flipname
--             vsplit
--             wincmd p
--             edit #
--             wincmd p
--         endif
--     endfun
-- ]])
