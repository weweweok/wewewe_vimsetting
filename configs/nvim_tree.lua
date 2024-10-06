-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- OR setup with some options
require("nvim-tree").setup({
	sort = {
		sorter = "case_sensitive",
	},
	view = {
		width = 30,
	},
	renderer = {
		highlight_git = true,
		highlight_opened_files = 'name',
		icons = {
			glyphs = {
				git = {
					unstaged = '!',
					renamed = '»',
					untracked = '?',
					deleted = '✘',
					staged = '✓',
					unmerged = '',
					ignored = '◌',
				},
			},
		},
	},
	filters = {
		dotfiles = false,
		git_ignored = false
	},
})
