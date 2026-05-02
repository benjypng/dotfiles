local function get_js_formatters(bufnr)
  local biome_config = vim.fs.find({ 'biome.json', 'biome.jsonc' }, {
    upward = true,
    path = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)),
  })[1]

  if biome_config then
    return { 'biome' }
  else
    return { 'prettier' }
  end
end

return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_format = 'never' }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = {
      timeout_ms = 500,
      lsp_format = 'never',
    },
    formatters_by_ft = {
      javascript = get_js_formatters,
      javascriptreact = get_js_formatters,
      typescript = get_js_formatters,
      typescriptreact = get_js_formatters,
      json = { 'prettier' },
      jsonc = { 'prettier' },
      css = { 'prettier' },
      scss = { 'prettier' },
      html = { 'prettier' },
      markdown = { 'prettier' },
      yaml = { 'prettier' },
      python = { 'isort', 'black' },
      lua = { 'stylua' },
    },
  },
}
