return {
  'loctvl842/monokai-pro.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('monokai-pro').setup {
      transparent_background = true,
    }
    vim.cmd.colorscheme 'monokai-pro'

    local groups = {
      'Normal', 'NormalNC', 'NormalFloat', 'FloatBorder', 'FloatTitle',
      'SignColumn', 'LineNr', 'EndOfBuffer', 'VertSplit', 'WinSeparator',
      'StatusLine', 'StatusLineNC', 'TabLine', 'TabLineFill',
      'NeoTreeNormal', 'NeoTreeNormalNC', 'NeoTreeEndOfBuffer',
      'TelescopeNormal', 'TelescopeBorder',
      'WhichKeyFloat',
    }
    for _, g in ipairs(groups) do
      vim.api.nvim_set_hl(0, g, { bg = 'NONE' })
    end
  end,
}
