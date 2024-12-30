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
    keys = {
      {
        '<leader>ff',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = {
        stop_after_first = false, -- Changed to false to allow multiple formatters
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
        typescript = { 'eslint_d', 'prettierd' },  -- Run eslint_d first, then prettierd
        typescriptreact = { 'eslint_d', 'prettierd' },
        javascript = { 'eslint_d', 'prettierd' },
        javascriptreact = { 'eslint_d', 'prettierd' },
        json = { 'prettierd' },
        css = { 'prettierd' },
      },
      -- Add ESLint formatter configuration
      formatters = {
        eslint_d = {
          -- Tell conform.nvim to use eslint_d's --fix option
          command = "eslint_d",
          args = { "--fix-to-stdout", "--stdin", "--stdin-filename", "$FILENAME" },
          stdin = true,
        },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
