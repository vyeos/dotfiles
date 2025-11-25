return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local function get_lsp_name()
			local msg = "No Active LSP"
			local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
			local clients = vim.lsp.get_clients()

			if next(clients) == nil then
				return msg
			end

			for _, client in ipairs(clients) do
				local filetypes = client.config.filetypes
				if not filetypes then
					return client.name
				end

				if vim.tbl_contains(filetypes, buf_ft) then
					return client.name
				end
			end

			return msg
		end

		require("lualine").setup({
			options = {
				theme = "auto", -- auto, everforest, gruvbox, material, palenight
				globalstatus = true, -- Have one single bar at the bottom (great for splits)
				component_separators = { left = "/", right = "/" },
				section_separators = { left = "", right = "" },
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = {
					"branch",
					{
						"diff",
						symbols = { added = " ", modified = " ", removed = " " },
					},
				},
				lualine_c = {
					"filename",
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						symbols = { error = " ", warn = " ", info = " ", hint = " " },
					},
				},

				lualine_x = {
					get_lsp_name,
					"encoding",
					"fileformat",
					"filetype",
				},
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			-- Extensions make the bar look better in specific windows
			extensions = { "fugitive", "mason", "lazy" },
		})
	end,
}
