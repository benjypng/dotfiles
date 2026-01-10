local hour = tonumber(os.date '%H')

return {
  'loctvl842/monokai-pro.nvim',
  config = function()
    local selected_filter = 'spectrum'
    if hour >= 8 and hour < 18 then
      selected_filter = 'light'
    end
    require('monokai-pro').setup {
      filter = selected_filter,
    }
    vim.cmd.colorscheme 'monokai-pro'
  end,
}
