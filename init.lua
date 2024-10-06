-- var settings
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.updatetime = 300
vim.opt.clipboard = "unnamedplus"
vim.o.guifont = "JetBrainsMono Nerd Font"
vim.opt.ambiwidth = "single"
vim.opt.termguicolors = true
vim.cmd.colorscheme("vim")
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.number = true
vim.opt.autoindent = true
vim.opt.signcolumn = "yes"




-- open terminal

-- Create the cache directory if it doesn't exist
local CACHE = vim.fn.expand('~/.cache')
if not vim.fn.isdirectory(CACHE) then vim.fn.mkdir(CACHE, 'p') end

-- neovide settings
if vim.g.neovide then
	-- font settings
	vim.o.guifont = "Monospace:h14" -- text below applies for VimScript

	vim.opt.linespace = 0

	vim.g.neovide_text_gamma = 0.0
	vim.g.neovide_text_contrast = 0.5

	vim.g.neovide_padding_top = 0
	vim.g.neovide_padding_bottom = 0
	vim.g.neovide_padding_right = 0
	vim.g.neovide_padding_left = 0
	vim.g.neovide_fullscreen = true
	vim.g.neovide_remember_window_size = true

	vim.g.neovide_theme = 'auto'
	vim.g.neovide_refresh_rate = 60
	vim.g.neovide_refresh_rate_idle = 5
	vim.g.neovide_input_ime = true
	vim.g.neovide_cursor_animation_length = 0.03

	vim.g.neovide_cursor_trail_size = 0.8
	vim.g.neovide_cursor_vfx_mode = "sonicboom"
end

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
