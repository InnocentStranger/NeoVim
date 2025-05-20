vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy", -- this runs after lazy.nvim has loaded all plugins
	callback = function()
		local ok, cs = pcall(require, "config.last_colorscheme")
		local scheme = (ok and cs.name) or "blue"

		local success, _ = pcall(vim.cmd, "colorscheme " .. scheme)
		if not success then
			vim.notify("Colorscheme '" .. scheme .. "' not found. Falling back to 'blue'.", vim.log.levels.WARN)
			vim.cmd("colorscheme blue")
		end
	end,
})
