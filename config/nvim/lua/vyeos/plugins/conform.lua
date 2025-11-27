return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				javascript = { "prettier" },
				typescript = { "biome" },
				javascriptreact = { "prettier" },
				typescriptreact = { "biome" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				lua = { "stylua" },
				go = { "golangci-lint" },
				python = { "black" },
				c = { "clang-format" },
				cpp = { "clang-format" },
			},
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 500,
			},
		})
		vim.keymap.set("n", "<leader>fm", function()
			require("conform").format({ bufnr = 0 })
		end)
	end,
}
