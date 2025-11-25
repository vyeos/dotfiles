return {
	"tpope/vim-fugitive",
	config = function()
		vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

		vim.keymap.set("n", "<leader>gc", ":Git commit<CR>")
		vim.keymap.set("n", "<leader>gp", ":Git push<CR>")
	end,
}

-- Press <leader>gs.
-- You see the status window.
-- Press s to stage a file (add).
-- Press u to unstage.
-- Press = to see the diff inline.
-- Press cc to commit.
