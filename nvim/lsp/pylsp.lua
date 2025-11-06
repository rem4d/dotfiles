return {
	cmd = { "pylsp" },
	filetypes = { "python" },
	root_markers = {
		"pyproject.toml",
		"setup.py",
		"setup.cfg",
		"requirements.txt",
		"Pipfile",
		".git",
	},
	settings = {
		pylsp = {
			plugins = {
				pycodestyle = {
					enabled = true,
					ignore = "E501,W503",
					maxLineLength = 88,
				},
			},
		},
	},
}
