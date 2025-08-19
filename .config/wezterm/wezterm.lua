local wezterm = require("wezterm")

return {
	-- Font (pick your own if you like)
	font = wezterm.font_with_fallback({ "MonoLisa Nerd Font" }),
	font_size = 14.0,

	-- Enable undercurl + underline colors
	underline_thickness = "2px",
	underline_position = "-2px",

	-- TrueColor
	enable_kitty_graphics = true,
	color_scheme = "Catppuccin Mocha", -- or any built-in scheme you like

	enable_tab_bar = false,

	window_decorations = "RESIZE",

	default_prog = { "/bin/zsh", "-l", "-c", "tmux attach || tmux" },

	-- Key: Make sure TERM is correct for Neovim + tmux
	term = "wezterm",
}
