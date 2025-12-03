return {
	{
		"neanias/everforest-nvim",
		priority = 1000,
		config = function()
			require("everforest").setup({
				-- Optional: Add Everforest specific config here
				background = "hard",
			})
		end,
	},
	{
		"marko-cerovac/material.nvim",
		priority = 1000,
		config = function()
			-- Set the specific style (options: 'darker', 'lighter', 'oceanic', 'palenight', 'deep ocean')
			vim.g.material_style = "darker"

			require("material").setup({
				contrast = {
					terminal = false,
					sidebars = false,
					floating_windows = false,
					cursor_line = false,
					non_current_windows = false,
					filetypes = {},
				},
				plugins = {
					"gitsigns",
					"nvim-cmp",
					"telescope",
				},
			})
		end,
	},
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		config = function()
			require("gruvbox").setup({
				terminal_colors = true,
				undercurl = true,
				underline = false,
				bold = true,
				italic = {
					strings = false,
					emphasis = false,
					comments = false,
					operators = false,
					folds = false,
				},
				strikethrough = true,
				inverse = true,
				contrast = "",
				dim_inactive = false,
				transparent_mode = true,
			})

			-- The "_G" makes it available everywhere in Neovim
			_G.Theme = function(name)
				vim.cmd.colorscheme(name)
			end
			vim.api.nvim_create_user_command("Theme", function(args)
				_G.Theme(args.args)
			end, {
				nargs = 1,
				complete = "color",
			})

			-- Set default theme
			vim.cmd.colorscheme("gruvbox")
		end,
	},
}
