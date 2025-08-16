return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },

      {
        'saghen/blink.cmp',
        dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
        version = '*',
        opts = {
          keymap = {
            preset = 'none',
            ['<S-Tab>'] = { 'select_prev', 'fallback' },
            ['<Tab>'] = { 'select_next', 'fallback' },
            ['<CR>'] = { 'accept', 'fallback' },
          },
          appearance = {
            use_nvim_cmp_as_default = false,
            nerd_font_variant = 'mono',
          },
          completion = {
            documentation = {
              auto_show = true,
              auto_show_delay_ms = 500,
            },
            menu = {
              draw = {
                columns = { { 'label', 'label_description' }, { 'kind' }, { 'source_name' } },
              },
            },
          },
          sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer' },
          },
        },
        opts_extend = { 'sources.default' },
      },

      {
        'pmizio/typescript-tools.nvim',
        dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
        opts = function()
          require('typescript-tools').setup {}
        end,
      },
    },

    config = function()
      vim.lsp.set_log_level 'ERROR'

      local capabilities = require('blink.cmp').get_lsp_capabilities()

      local servers = {
        dockerls = {},
        eslint = {},
        html = {},
        jsonls = {
          settings = {
            json = {
              validate = { enable = true },
              schemaValidation = 'ignore',
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { disable = { 'missing-fields' }, globals = { 'vim' } },
              workspace = {
                library = vim.api.nvim_get_runtime_file('', true),
              },
              format = { enable = true },
              telemetry = { enable = false },
            },
          },
        },
        prettierd = {},
        prismals = {},
        stylua = {},
        yamlls = {
          settings = { yaml = { validate = false } },
        },
      }

      -- Mason setup
      require('mason').setup()
      require('mason-tool-installer').setup {
        ensure_installed = vim.tbl_keys(servers),
      }
      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }

      -- Diagnostics handler
      vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        update_in_insert = false,
        virtual_text = { spacing = 0, prefix = '' },
      })

      vim.api.nvim_create_autocmd('BufWritePre', {
        callback = function(args)
          local buf = args.buf
          local clients = vim.lsp.get_active_clients { bufnr = buf }
          for _, client in ipairs(clients) do
            if client.server_capabilities.documentFormattingProvider then
              vim.lsp.buf.format { bufnr = buf }
              return
            end
          end
        end,
      })

      -- Auto-commands for LSP
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              callback = function()
                vim.defer_fn(vim.lsp.buf.document_highlight, 150)
              end,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })
    end,
  },
}
