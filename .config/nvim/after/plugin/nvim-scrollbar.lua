require("scrollbar").setup()
require("scrollbar.handlers.gitsigns").setup()

-- show last jump position
-- press <C-o> to go there
-- source: https://github.com/petertriho/nvim-scrollbar/discussions/64
require("scrollbar.handlers").register("lastjump", function(bufnr)
	local lastJump = vim.fn.getjumplist()[2]
	local lastJumpPos = vim.fn.getjumplist()[1][lastJump]
	if lastJumpPos.bufnr == bufnr then
		return { {
			line = lastJumpPos.lnum,
			text = "▶️",
			type = "Misc",
			level = 6,
		} }
	end
	return { { line = 0, text = "" } } -- dummy-return to prevent error
end)
