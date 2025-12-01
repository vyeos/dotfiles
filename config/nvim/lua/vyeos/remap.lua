local M = {}

vim.g.mapleader = " "
vim.keymap.set("n", "<C-n>", vim.cmd.Ex)

M.general = {
	i = {},

	n = {
		["<C-u>"] = { "<C-u>zz" },
		["<C-d>"] = { "<C-d>zz" },
		["n"] = { "nzzzv" },
		["N"] = { "Nzzzv" },
		["=ap"] = { "map=ap'a" },
		-- Copy all
		["<C-c>"] = { "<cmd> %y+ <CR>", "Copy whole file" },
	},
	v = {},
	x = {
		["<C-n>"] = { "<cmd> Ex <CR>" },
	},
}

return M
