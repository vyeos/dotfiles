return {
	{
		"3rd/image.nvim",
		build = false, -- specific build steps usually not needed if system imagemagick is present
		opts = {
			backend = "kitty", -- Use "kitty" even if you are using Ghostty
			integrations = {
				markdown = {
					enabled = true,
					clear_in_insert_mode = false,
					download_remote_images = true,
					only_render_image_at_cursor = false,
					filetypes = { "markdown", "vimwiki", "html" },
				},
				neorg = {
					enabled = true,
					filetypes = { "norg" },
				},
			},
			max_width = nil,
			max_height = nil,
			max_width_window_percentage = nil,
			max_height_window_percentage = 50,
			window_overlap_clear_enabled = false,
			editor_only_render_when_focused = false, -- Render images even when window isn't focused
			hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- Renders these files as images automatically
		},
	},
}
