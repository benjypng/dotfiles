-- lua/plugins/lsp.lua
return {
  { 'williamboman/mason.nvim',     opts = {} },

  {
    'neovim/nvim-lspconfig',
    -- Can remove comment if loading is slow
    --    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'williamboman/mason.nvim',
      'pmizio/typescript-tools.nvim',
      'echasnovski/mini.completion',
    },
    config = function()
      local lspconfig = require 'lspconfig'

      -- Capabilities (enable snippet support for things like html/css/json, etc.)
      local function lsp_capabilities()
        local caps = vim.lsp.protocol.make_client_capabilities()
        caps.textDocument.completion.completionItem.snippetSupport = true
        return caps
      end

      -- on_attach: minimal maps, format-on-save, and your gd→vsplit behavior
      local function on_attach(client, bufnr)
        -- hard-disable LSP formatting so it never competes with Prettier
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false

        local map = function(mode, lhs, rhs)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr })
        end

        map('n', 'gd', function()
          vim.cmd 'vsplit'
          vim.lsp.buf.definition()
        end)
        map('n', 'gD', function()
          vim.cmd 'vsplit'
          vim.lsp.buf.declaration()
        end)
        map('n', 'K', vim.lsp.buf.hover)
        map('n', '<leader>rn', vim.lsp.buf.rename)
        map({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action)
      end

      -- Mason (installer UI only; no mason-lspconfig)
      require('mason').setup()

      -- Lua
      lspconfig.lua_ls.setup {
        capabilities = lsp_capabilities(),
        on_attach = on_attach,
        settings = {
          Lua = {
            diagnostics = { globals = { 'vim' } },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      }

      -- Eslint
      lspconfig.eslint.setup {
        settings = {
          format = false,  -- using conform
          validate = 'on', -- validate files
        },
        capabilities = lsp_capabilities(),
        on_attach = on_attach,
      }

      -- TypeScript / JavaScript (handled by typescript-tools)
      local ok_ts, ts_tools = pcall(require, 'typescript-tools')
      if ok_ts then
        ts_tools.setup {
          capabilities = lsp_capabilities(),
          on_attach = on_attach,
        }
      end

      -- Minimal completion via mini.completion (no docs/info popup)
      vim.o.completeopt = 'menu,menuone,noinsert'
      require('mini.completion').setup {
        set_vim_settings = true,
        lsp_completion = { source_func = 'omnifunc', auto_setup = true },
        delay = { completion = 100, info = nil, signature = 50 },
      }

      -- Tab / Shift-Tab to cycle the popup menu; Enter to accept
      local imap = function(lhs, rhs)
        vim.keymap.set('i', lhs, rhs, { expr = true, silent = true })
      end
      imap('<Tab>', function()
        return vim.fn.pumvisible() == 1 and '<C-n>' or '<Tab>'
      end)
      imap('<S-Tab>', function()
        return vim.fn.pumvisible() == 1 and '<C-p>' or '<S-Tab>'
      end)
      imap('<CR>', function()
        return vim.fn.pumvisible() == 1 and '<C-y>' or '<CR>'
      end)

      -- mini.snippets: load snippets + expose them to completion via in-process LSP
      local gen_loader = require('mini.snippets').gen_loader
      require('mini.snippets').setup {
        snippets = {
          -- 1) Language-scoped files from runtimepath: e.g.
          --    ~/.config/nvim/snippets/javascript.json
          --    ~/.config/nvim/snippets/typescript.json
          gen_loader.from_lang(),

          -- 2) (Optional) One global file visible in all buffers:
          gen_loader.from_file(vim.fn.stdpath 'config' .. '/snippets/global.json'),
        },
      }
      require('mini.snippets').start_lsp_server { match = false }
    end,
  },

  { 'echasnovski/mini.completion', event = 'InsertEnter', version = '*' },
  { 'echasnovski/mini.snippets',   event = 'InsertEnter' },
}
