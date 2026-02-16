local function get_js_formatters(bufnr)
  local biome_config = vim.fs.find({ 'biome.json', 'biome.jsonc' }, {
    upward = true,
    path = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)),
  })[1]

  if biome_config then
    return { 'biome' }
  else
    return { 'prettier', 'eslint_d' }
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
    notify_on_error = true,
    format_on_save = function(bufnr)
      local lsp_format_opt = 'never'
      return {
        timeout_ms = 500,
        lsp_format = lsp_format_opt,
      }
    end,
    formatters_by_ft = {
      javascript = get_js_formatters,
      javascriptreact = get_js_formatters,
      typescript = get_js_formatters,
      typescriptreact = get_js_formatters,
      json = { 'prettier' },
      css = { 'prettier' },
      python = { 'isort', 'black' },
      lua = { 'stylua' },
    },
  },
}
