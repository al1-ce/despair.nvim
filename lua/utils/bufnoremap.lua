local opts = { noremap = true, silent = true }

local function noremap(mode, keys, target, options)
    local t
    if options == nil then
        t = opts
    else
        t = options
        t.noremap = opts.noremap
        t.silent = opts.silent
    end
    vim.api.nvim_buf_set_keymap(0, mode, keys, target, t)
end

return noremap

