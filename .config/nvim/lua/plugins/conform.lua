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
    format_on_save = function(bufnr)
      local lsp_format_opt = 'never'
      return {
        timeout_ms = 500,
        lsp_format = lsp_format_opt,
      }
    end,
    formatters_by_ft = {
      javascript = { 'biome', 'biome-organize-imports', 'prettierd', 'eslint_d', stop_after_first = true },
      javascriptreact = { 'biome', 'biome-organize-imports', 'prettierd', 'eslint_d', stop_after_first = true },
      typescript = { 'biome', 'biome-organize-imports', 'prettierd', 'eslint_d', stop_after_first = true },
      typescriptreact = { 'biome', 'biome-organize-imports', 'prettierd', 'eslint_d', stop_after_first = true },
      json = { 'biome', 'biome-organize-imports' },
      -- javascript = { 'prettierd', 'eslint_d' },
      -- javascriptreact = { 'prettierd', 'eslint_d' },
      -- typescript = { 'prettierd', 'eslint_d' },
      -- typescriptreact = { 'prettierd', 'eslint_d' },
      -- json = { 'prettierd' },
      css = { 'prettierd' },
      python = { 'isort', 'black' },
      lua = { 'stylua' },
    },
  },
}
