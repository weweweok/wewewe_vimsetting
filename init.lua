-- Using vim-plug requires installing vim-plug from https://github.com/junegunn/vim-plug
-- Set the directory for LSP servers
local lsp_settings_servers_dir = '~/.config/nvim/lsp/'

-- Create the cache directory if it doesn't exist
local CACHE = vim.fn.expand('~/.cache')
if not vim.fn.isdirectory(CACHE) then vim.fn.mkdir(CACHE, 'p') end

-- Install dein.vim if it's not already installed
if not vim.fn.exists('g:dein#') then
    local dein_dir = vim.fn.fnamemodify('dein.vim', ':p')
    if not vim.fn.isdirectory(dein_dir) then
        dein_dir = CACHE .. '/dein/repos/github.com/Shougo/dein.vim'
        if not vim.fn.isdirectory(dein_dir) then
            vim.fn.system('git clone https://github.com/Shougo/dein.vim ' ..
                              dein_dir)
        end
    end
    vim.o.runtimepath = dein_dir .. ',' .. vim.o.runtimepath
end

-- Load various vim files from the config directory
vim.cmd('source ~/.config/nvim/configs/setplug.vim')

local splt = vim.fn.split(vim.fn.glob("~/.config/nvim/configs/*.{vim,lua}"),
                          '\n')

for _, file in ipairs(splt) do
    -- Print the loaded file (you can remove this line if desired)
    print("load " .. file)
    -- Load the file
    vim.cmd('source ' .. file)
end


