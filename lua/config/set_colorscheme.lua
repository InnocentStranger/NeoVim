local M = {}

-- Function to set and save the selected colorscheme
function M.set_and_save_colorscheme(name)
	-- Save the selected colorscheme to a Lua file
	local config_path = vim.fn.stdpath("config") .. "/lua/config/last_colorscheme.lua"
	local file = io.open(config_path, "w")
	if file then
		file:write('return { name = "' .. name .. '" }\n')
		file:close()
		-- Set the colorscheme in Neovim
		vim.cmd("colorscheme " .. name)
		print("Successfully changed colorscheme ")
	else
		print("Error: Unable to write to " .. config_path)
	end
end

return M
