return {
  'stevearc/oil.nvim',
  opts = {},
  -- Optional dependencies
  -- dependencies = { { "echasnovski/mini.icons", opts = {} } },
  dependencies = { 'nvim-tree/nvim-web-devicons' }, -- use if prefer nvim-web-devicons
  config = function()
    require('oil').setup {
      columns = {
        'icon',
        'size',
      },
      view_options = {
        show_hidden = true,
      },
      delete_to_trash = true,
      keymaps = {
        ['<C-v>'] = { 'actions.select', opts = { vertical = true }, desc = 'Open the entry in a vertical split' },
      },
    }
  end,
}
