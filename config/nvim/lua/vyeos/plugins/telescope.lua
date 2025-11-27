return {
	"nvim-telescope/telescope.nvim",
	tag = "v0.1.9",
	dependencies = { "nvim-lua/plenary.nvim" },

	config = function()
		local telescope = require("telescope")
		local builtin = require("telescope.builtin")

		telescope.setup({})

		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
		vim.keymap.set("n", "<leader>fw", builtin.live_grep, { desc = "Live grep" })
		vim.keymap.set("n", "<leader>fa", "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>")
		vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })

		--   vim.keymap.set("n", "<leader>th", function()
		--     local theme = require("telescope.themes").get_dropdown({
		--       previewer = false,
		--       layout_config = {
		--         height = 0.8,
		--         width = 0.4,
		--         prompt_position = "top",
		--       },
		--     })
		--     require('telescope.builtin').colorscheme {
		--       enable_preview = true,
		--       theme = theme
		--     }
		-- end)
	end,
}
