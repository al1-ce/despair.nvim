local hl = require('hlgroups')
local ti = require('timer')

local M = {}

M.gen_hl_groups = function()
    local colors = {
        replace = hl('Keyword').fg    or "#fe0000",
        insert  = hl('PmenuSbar').bg  or "#fe0000",
        visual  = hl('Number').fg     or "#fe0000",
        command = hl('Identifier').fg or "#fe0000",
        fore    = hl('Normal').fg     or "#fe0000",
        back    = hl('Normal').bg     or "#fe0000"
    }

    vim.api.nvim_set_hl(0, "DesStatusNormal",     { bg = colors.back, fg = colors.fore })
    vim.api.nvim_set_hl(0, "DesStatusNormalBold", { bg = colors.back, fg = colors.fore, bold = true })
    vim.api.nvim_set_hl(0, "DesStatusInsert",   { bg = colors.insert, fg = colors.fore, bold = true })
    vim.api.nvim_set_hl(0, "DesStatusReplace",  { fg = colors.replace, bold = true, reverse = true })
    vim.api.nvim_set_hl(0, "DesStatusVisual",   { fg = colors.visual, bold = true, reverse = true  })
    vim.api.nvim_set_hl(0, "DesStatusCommand",  { fg = colors.command, bold = true, reverse = true  })

end

M.reset_stline = function()
    if despair_statusline_reload_interval ~= nil then
        ti.clear_interval(despair_statusline_reload_interval)
        despair_statusline_reload_interval = nil
        vim.notify("Cleared statusline reload interval")
    end
end

M.start_stline = function()
    M.reset_stline()

    local interval_time = math.floor(250) 

    local draw_func = function()
        -- if vim.v.errmsg ~= "" then
        --     reset_stline()
        --     vim.v.errmsg = ""
        --     return
        -- end

        local function stline_get_mode()
            local m = vim.fn.mode()
            if m == "n"  then return " NOR " end
            if m == "R"  then return " REP " end
            if m == "v"  then return " VIS " end
            if m == "V"  then return " V-L " end
            if m == "^V" then return " V-B " end
            if m == "t"  then return " TER " end
            if m == "o"  then return " OPT " end
            if m == "c"  then return " COM " end
            if m == "i"  then return " INS " end
            return "CMD"
        end

        local function get_mode_hl()
            local m = vim.fn.mode()
            if m == "n"  then return "%#DesStatusNormalBold#" end
            if m == "R"  then return "%#DesStatusReplace#" end
            if m == "v"  then return "%#DesStatusVisual#" end
            if m == "V"  then return "%#DesStatusVisual#" end
            if m == "^V" then return "%#DesStatusVisual#" end
            if m == "t"  then return "%#DesStatusInsert#" end
            if m == "o"  then return "%#DesStatusInsert#" end
            if m == "c"  then return "%#DesStatusInsert#" end
            if m == "i"  then return "%#DesStatusInsert#" end
            return " [" .. m .. "]"
        end

        local function get_tape()
            local reg_cur = vim.fn.toupper(vim.fn.reg_recorded())
            local reg_rec = vim.fn.toupper(vim.fn.reg_recording())
            if reg_rec ~= "" then
                local stage = math.floor((vim.loop.now() / 250) % 4)
                if stage == 0     then return " [o o] Recording " .. reg_rec .. "..." end
                if stage % 4 == 1 then return " [o⠠o] Recording " .. reg_rec .. "..." end
                if stage % 4 == 2 then return " [o⠤o] Recording " .. reg_rec .. "..." end
                if stage % 4 == 3 then return " [o⠄o] Recording " .. reg_rec .. "..." end
            end
            if reg_cur ~= "" then
                return " [o o] Side " .. reg_cur
            end
            return " [o o] Side ?"
        end

        vim.opt.statusline = get_mode_hl() .. stline_get_mode() .. "%#DesStatusNormal# %F%m%h%r%=%{&ft}" .. get_tape() .. " " .. get_mode_hl() .. " %P %#Normal#"

    end


    M.gen_hl_groups()
    draw_func()
    despair_statusline_reload_interval = ti.set_interval(interval_time, draw_func)
end

return M
