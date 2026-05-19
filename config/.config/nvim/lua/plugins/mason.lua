return {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = true,
		opts = {
			ensure_installed = {
				"codelldb",
			},
		},
}
