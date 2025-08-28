local function trim_empty_lines_at_end(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, true)
  while #lines > 0 and lines[#lines]:match '^%s*$' do
    table.remove(lines)
  end
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, lines)
end

return {
  {
    'stevearc/conform.nvim',
    lazy = false,
    opts = {
      notify_on_error = false,

      -- format on save
      format_on_save = function(bufnr)
        -- never fall back to LSP for these (avoid tsserver)
        trim_empty_lines_at_end(bufnr)
        local hard = { javascript = true, typescript = true, javascriptreact = true, typescriptreact = true, json = true, css = true }
        return { timeout_ms = 800, lsp_fallback = not hard[vim.bo[bufnr].filetype] }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'isort', 'black' },
        typescript = { 'prettierd', 'prettier' },
        typescriptreact = { 'prettierd', 'prettier' },
        javascript = { 'prettierd', 'prettier' },
        javascriptreact = { 'prettierd', 'prettier' },
        --        json = { 'prettierd', 'prettier' },
        css = { 'prettierd', 'prettier' },
      },
      stop_after_first = false,
    },
  },
}
