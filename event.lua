local definitions = {
	-- Example
	bufs = {
		{ "BufWritePre", "COMMIT_EDITMSG", "setlocal noundofile" },
	},
}

vim.api.nvim_create_user_command("CexprSystem", function(opts)
	local cmd = opts.args
	-- If the command does not contain a “/”, add “./” (indicating the current directory)
	if not cmd:match("/") then
		cmd = "./" .. cmd
	end
	vim.cmd("cexpr system('" .. cmd .. "')")
	vim.cmd("copen")
end, {
	nargs = 1, -- A parameter must be present
	complete = "file", -- File path completion
})

vim.api.nvim_create_user_command("CexprSystemTrouble", function(opts)
	local cmd = opts.args
	-- If the command does not contain a “/”, it will default to adding “./” to denote the current directory
	if not cmd:match("/") then
		cmd = "./" .. cmd
	end

	-- Execute command
	local output = vim.fn.systemlist(cmd)

	-- Convert the output into a quickfix item recognisable by trouble
	local qf_list = {}
	for _, line in ipairs(output) do
		-- Matching filename:linenumber:message format
		local file, lnum, msg = line:match("([^:]+):(%d+):(.+)")
		if file and lnum and msg then
			table.insert(qf_list, {
				filename = file,
				lnum = tonumber(lnum),
				col = 1, -- Can be changed to a specific column as required.
				text = msg,
			})
		end
	end

	-- Set up the quickfix list
	vim.fn.setqflist({}, " ", { title = "CexprSystemTrouble", items = qf_list })

	-- Invoke trouble to display quickfix
	vim.cmd("Trouble quickfix")
end, {
	nargs = 1, -- A parameter must be present
	complete = "file", -- Path completion
})

return definitions
