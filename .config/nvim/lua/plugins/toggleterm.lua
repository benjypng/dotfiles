return {
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      require('toggleterm').setup {
        direction = 'horizontal',
        size = 7,
      }
      vim.keymap.set('n', '<leader>tt', ':ToggleTerm<CR>')
      vim.keymap.set('t', '<esc>', '<C-\\><C-n>:ToggleTerm<CR>')
    end,
  },
}
