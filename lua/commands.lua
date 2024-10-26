
vim.api.nvim_create_user_command('Spell', function()
    vim.o.spell = not vim.o.spell
    if vim.o.spell then
        vim.notify("Turning spelling on")
    else
        vim.notify("Turning spelling off")
    end
end, {})

vim.api.nvim_create_user_command('Wrap', function()
    vim.o.wrap = not vim.o.wrap
    if vim.o.wrap then
        vim.notify("Turning wrap on")
    else
        vim.notify("Turning wrap off")
    end
end, {})

