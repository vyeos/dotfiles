return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"mason-org/mason.nvim",
		"mason-org/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		vim.diagnostic.config({
			virtual_text = true,
		})
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		local on_attach = function(client, bufnr)
			local opts = { buffer = bufnr, remap = false }
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
			vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
			vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
			vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
			vim.keymap.set("n", "[d", function()
				vim.diagnostic.jump({ count = -1, float = true })
			end, opts)
			vim.keymap.set("n", "]d", function()
				vim.diagnostic.jump({ count = 1, float = true })
			end, opts)
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
			vim.keymap.set("n", "<leader>rr", vim.lsp.buf.references, opts)
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		end

		vim.lsp.config("lua_ls", {
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				Lua = {
					diagnostics = { globals = { "vim" } },
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
					},
					runtime = { version = "LuaJIT" },
				},
			},
		})

		local servers = { "pyright", "ts_ls", "html", "cssls", "clangd", "gopls", "pylsp", "tailwindcss" }
		for _, server in ipairs(servers) do
			vim.lsp.config(server, {
				capabilities = capabilities,
				on_attach = on_attach,
			})
		end

		-- Make sure mason-lspconfig installs the servers
		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"pyright",
				"ts_ls",
				"html",
				"cssls",
				"lua_ls",
				"pylsp",
				"clangd",
				"tailwindcss",
			},
			automatic_enable = true,
		})
	end,
}
