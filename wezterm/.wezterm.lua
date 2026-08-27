local wezterm = require 'wezterm'

return {
  audible_bell = "Disabled",
  color_scheme = "Catppuccin Mocha",
  font_size = 14.0,

  -- important for your use case
  enable_tab_bar = true,
  use_fancy_tab_bar = true,
  keys = {
    {
      key = 'g',
      mods = 'CMD',
      action = wezterm.action.SplitPane {
        direction = 'Right',
        size = { Percent = 30 },
        command = {
          args = {
            'bash',
            '-lc',
            'watch -t -c -n 2 "git -c color.status=always status -sb"'
          },
        },
      },
    },
  },
}
