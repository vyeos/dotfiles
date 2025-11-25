return {
	"mason-org/mason.nvim",
	dependencies = {
		"mason-org/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		require("mason").setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		-- This ensures the tools you need are always present
		require("mason-tool-installer").setup({
			ensure_installed = {
				"lua_ls",
				"ts_ls",
				"html",
				"cssls",

				"prettier",
				"biome",
				"stylua",
				"black",
			},
			-- Auto-update tools on startup?
			auto_update = true,
			run_on_start = true,
		})

		require("mason-lspconfig").setup({
			-- This ensures LSPs are installed, but we handled that list above
			ensure_installed = {},
			automatic_installation = true,
		})
	end,
}
