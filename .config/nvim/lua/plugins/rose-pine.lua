return {
  'rose-pine/neovim',
  name = 'rose-pine',
  init = function()
    require('rose-pine').setup {
      variant = 'moon',
    }
    vim.cmd.colorscheme 'rose-pine'
    vim.cmd.hi 'LineNr guifg = #FFFFFF'
  end,
}