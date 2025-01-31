return {
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      { 'folke/neodev.nvim', opts = {} },
      {
        'pmizio/typescript-tools.nvim',
        dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
        opts = {
          settings = {
            separate_diagnostic_server = true,
            publish_diagnostic_on = 'insert_leave',
            expose_as_code_action = 'all',
            tsserver_path = nil,
            tsserver_plugins = {},
            tsserver_max_memory = 'auto',
            tsserver_format_options = {},
            tsserver_file_preferences = {
              includeInlayParameterNameHints = 'none',
              includeInlayPropertyDeclarationTypeHints = false,
              includeInlayFunctionLikeReturnTypeHints = false,
              includeInlayVariableTypeHints = false,
              includeInlayEnumMemberValueHints = false,
              includeCompletionsForModuleExports = false,
              includeCompletionsForImportStatements = false,
            },
          },
        },
      },
    },
    config = function()
      vim.lsp.set_log_level 'ERROR'

      local debounce = function(fn, ms)
        local timer = vim.loop.new_timer()
        return function(...)
          local args = { ... }
          timer:start(ms, 0, function()
            timer:stop()
            vim.schedule_wrap(fn)(unpack(args))
          end)
        end
      end

      vim.lsp.handlers['textDocument/hover'] = debounce(vim.lsp.handlers.hover, 100)
      vim.lsp.handlers['textDocument/signatureHelp'] = debounce(vim.lsp.handlers.signature_help, 100)

      vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          prefix = '●',
        },
      })

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            local highlight_debounced = debounce(vim.lsp.buf.document_highlight, 150)
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              callback = highlight_debounced,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      vim.api.nvim_create_autocmd('BufReadPre', {
        pattern = '*',
        callback = function(opts)
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(opts.buf))
          local size_kb = ok and stats and stats.size / 1024 or 0
          if size_kb > 100 then
            vim.opt_local.spell = false
            vim.opt_local.swapfile = false
            vim.opt_local.undofile = false
            vim.opt_local.breakindent = false
            vim.cmd 'LspStop'
          end
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()

      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      local servers = {
        stylua = {},
        eslint_d = {},
        dockerls = {},
        jsonls = {
          settings = {
            json = {
              validate = {
                enable = true,
                schemaValidation = 'ignore',
              },
            },
          },
        },
        prismals = {},
        yamlls = {
          settings = {
            yaml = {
              validate = false,
            },
          },
        },
        html = {
          filetypes = { 'html', 'handlebars' },
        },
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { disable = { 'missing-fields' } },
              format = {
                enable = true,
                defaultConfig = {
                  indent_style = 'space',
                  indent_size = '2',
                },
              },
              workspace = {
                maxPreload = 2000,
                preloadFileSize = 1000,
              },
              telemetry = { enable = false },
            },
          },
        },
      }

      require('mason').setup()

      local ensure_installed = vim.tbl_keys(servers or {})
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            server.flags = server.flags or {}
            server.flags.debounce_text_changes = 150
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
}
