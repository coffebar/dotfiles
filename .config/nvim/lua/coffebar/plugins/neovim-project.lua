local synced_path = "~/Sync/nvim"
local datapath
if vim.fn.isdirectory(vim.fn.expand(synced_path)) == 1 then
	datapath = synced_path
else
	-- if hard-coded path not exists on current machine,
	-- use ~/.local/share/nvim/
	datapath = vim.fn.stdpath("data")
end

return {
	-- Parent directories for projects
	projects = {
		"~/.config/*",
		"~/dev/*",
		"~/dev/Sc*/*",
		"~/dev/star*/*",
		"~/dev/Ch*/*",
		"~/pets/*",
		"~/pets/AU*/*",
	},
	-- Path to store history and sessions
	datapath = datapath,
}
