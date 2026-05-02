hl.config({
	input = {
		kb_layout = "us,ua",
		kb_variant = "",
		kb_model = "",
		kb_options = "grp:alt_shift_toggle,caps:backspace",
		kb_rules = "",
		follow_mouse = 1,
		sensitivity = 0,
		touchpad = {
			natural_scroll = false,
			tap_button_map = "lmr",
		},
	},

	general = {
		gaps_in = 2,
		gaps_out = 0,
		border_size = 1,
		col = {
			active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
			inactive_border = "rgba(595959aa)",
		},
		layout = "dwindle",
	},

	decoration = {
		rounding = 0,
		blur = {
			enabled = false,
		},
	},

	animations = {
		enabled = false,
	},

	dwindle = {
		force_split = 1,
	},

	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		disable_autoreload = true,
	},

	ecosystem = {
		no_update_news = true,
	},

	debug = {
		disable_logs = false,
	},
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
