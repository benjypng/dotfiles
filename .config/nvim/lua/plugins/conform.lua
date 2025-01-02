local function trim_empty_lines_at_end(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, true)
  while #lines > 0 and lines[#lines]:match '^%s*$' do
    table.remove(lines)
  end
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, lines)
end

return {
  { -- Autoformat
    'stevearc/conform.nvim',
    lazy = false,
    opts = {
      notify_on_error = false,
      format_on_save = {
        stop_after_first = false, -- Changed to false to allow multiple formatters
        timeout_ms = 500,
        function(bufnr)
          -- Disable "format_on_save lsp_fallback" for languages that don't
          -- have a well standardized coding style. You can add additional
          -- languages here or re-enable it for the disabled ones.
          -- Call the function to trim empty lines
          trim_empty_lines_at_end(bufnr)
          local disable_filetypes = { c = true, cpp = true }
          return {
            timeout_ms = 500,
            lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
          }
        end,
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'isort', 'black' },
        typescript = { 'prettierd' },
        typescriptreact = { 'prettierd' },
        javascript = { 'prettierd' },
        javascriptreact = { 'prettierd' },
        json = { 'prettierd' },
        css = { 'prettierd' },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
