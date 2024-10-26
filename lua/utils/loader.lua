local function load(m)
    local ok, err = pcall(require, m)
    if not ok then
        vim.notify("Package \"" .. m .. "\" failed to load. \n\n" .. err, vim.log.levels.error)
    end
end

return load
