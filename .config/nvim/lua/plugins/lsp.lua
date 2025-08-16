-- lua/plugins/lsp.lua
return {
  -- Mason (installer)
  {
    'williamboman/mason.nvim',
    cmd = { 'Mason', 'MasonInstall', 'MasonUpdate' },
    opts = {
      ui = { border = 'rounded' },
    },
  },

  -- LSP + Mason bridge + TS tools + completion (blink.cmp)
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'pmizio/typescript-tools.nvim',
      'saghen/blink.cmp', -- completion
    },
    config = function()
      -------------------------------------------------------------------------
      -- Diagnostics UI
      -------------------------------------------------------------------------
      local signs = { Error = '', Warn = '', Hint = '', Info = '' }
      for name, icon in pairs(signs) do
        local hl = 'DiagnosticSign' .. name
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
      end
      vim.diagnostic.config {
        virtual_text = { spacing = 2, prefix = '●' },
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
      }

      -------------------------------------------------------------------------
      -- Capabilities (prefer blink.cmp if present; fall back to cmp_nvim_lsp or vanilla)
      -------------------------------------------------------------------------
      local function lsp_capabilities()
        local caps = vim.lsp.protocol.make_client_capabilities()
        local ok_blink, blink = pcall(require, 'blink.cmp')
        if ok_blink and blink and blink.get_lsp_capabilities then
          caps = blink.get_lsp_capabilities(caps)
          return caps
        end
        local ok_cmp, cmp = pcall(require, 'cmp_nvim_lsp')
        if ok_cmp and cmp and cmp.default_capabilities then
          caps = cmp.default_capabilities(caps)
        end
        return caps
      end

      -------------------------------------------------------------------------
      -- on_attach: buffer-local keymaps and formatting on save
      -------------------------------------------------------------------------
      local function on_attach(client, bufnr)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        map('n', 'gd', function() vim.cmd("vsplit") vim.lsp.buf.definition() end, 'LSP: Go to Definition')
        map('n', 'gD', vim.lsp.buf.declaration, 'LSP: Go to Declaration')
        map('n', 'gi', vim.lsp.buf.implementation, 'LSP: Go to Implementation')
        map('n', 'gr', vim.lsp.buf.references, 'LSP: References')
        map('n', 'K', vim.lsp.buf.hover, 'LSP: Hover')
        map('n', '<leader>rn', vim.lsp.buf.rename, 'LSP: Rename')
        map({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, 'LSP: Code Action')
        map('n', '<leader>ds', vim.diagnostic.open_float, 'Diagnostics: Line')
        map('n', '[d', vim.diagnostic.goto_prev, 'Diagnostics: Prev')
        map('n', ']d', vim.diagnostic.goto_next, 'Diagnostics: Next')

        -- Format on save (opt-in: enable for servers that support it)
        if client.supports_method 'textDocument/formatting' then
          local group = vim.api.nvim_create_augroup('LspFormat.' .. bufnr, { clear = true })
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = group,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format { bufnr = bufnr, timeout_ms = 2000 }
            end,
          })
        end
      end

      -------------------------------------------------------------------------
      -- Mason & mason-lspconfig: install servers
      -- Note: we DO install `tsserver` (typescript-language-server) via Mason,
      -- but we DO NOT set it up with lspconfig—`typescript-tools` handles TS.
      -------------------------------------------------------------------------
      require('mason').setup()

      local ensure = {
        'lua_ls',
        'bashls',
        'jsonls',
        'yamlls',
        'html',
        'cssls',
        'ts_ls',
      }

      require('mason-lspconfig').setup {
        ensure_installed = ensure,
        automatic_installation = true,
      }

      -------------------------------------------------------------------------
      -- lspconfig servers (exclude tsserver; handled by typescript-tools)
      -------------------------------------------------------------------------
      local lspconfig = require 'lspconfig'
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = 'Replace' },
              diagnostics = { globals = { 'vim' } },
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
            },
          },
        },
        bashls = {},
        jsonls = {},
        yamlls = {},
        html = {},
        cssls = {},
        prettierd = {},
      }

      for name, opts in pairs(servers) do
        opts.capabilities = lsp_capabilities()
        opts.on_attach = on_attach
        lspconfig[name].setup(opts)
      end

      -------------------------------------------------------------------------
      -- TypeScript via typescript-tools
      -------------------------------------------------------------------------
      local has_ts, ts_tools = pcall(require, 'typescript-tools')
      if has_ts then
        ts_tools.setup {
          -- Forward capabilities & on_attach for a consistent experience
          capabilities = lsp_capabilities(),
          on_attach = on_attach,
          settings = {
            -- examples; tweak to taste
            separate_diagnostic_server = true,
            publish_diagnostic_on = 'insert_leave',
            expose_as_code_action = 'all',
            tsserver_max_memory = 'auto',
            tsserver_file_preferences = {
              includeInlayParameterNameHints = 'all',
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayVariableTypeHintsWhenTypeMatchesName = false,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
        }
      end
    end,
  },

  -- blink.cmp (completion). Minimal opts; configure further if you like.
  {
    'saghen/blink.cmp',
    event = 'InsertEnter',
    opts = {
      -- Defaults are good; you can add sources/snippets/mappings here.
      keymap = {
        -- Tab to move forward
        ['<Tab>'] = { 'select_next', 'fallback' },
        -- Shift+Tab to move backward
        ['<S-Tab>'] = { 'select_prev', 'fallback' },
        -- Enter to confirm selection
        ['<CR>'] = { 'accept', 'fallback' },
      },
    },
  },

  -- (Optional) If you also want snippets, add your snippet engine here.
}
