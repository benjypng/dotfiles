return {
  { 'williamboman/mason.nvim', opts = {} },
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'williamboman/mason.nvim',
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
    config = function()
      -- Completion setup
      vim.o.completeopt = 'menu,menuone,noinsert'
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ['<Tab>'] = function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end,
          ['<S-Tab>'] = function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end,
          ['<CR>'] = cmp.mapping.confirm { select = true },
          ['<C-e>'] = cmp.mapping.abort(),
          ['<C-Space>'] = cmp.mapping.complete(),
        },
        sources = cmp.config.sources({ { name = 'nvim_lsp' }, { name = 'luasnip' } }, { { name = 'path' }, { name = 'buffer' } }),
      }

      -- Shared capabilities
      local function lsp_capabilities()
        local caps = vim.lsp.protocol.make_client_capabilities()
        return require('cmp_nvim_lsp').default_capabilities(caps)
      end

      -- Shared on_attach: keymaps, disable LSP formatting (conform handles it)
      local function on_attach(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false

        local map = function(mode, lhs, rhs)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr })
        end

        map('n', 'gd', vim.lsp.buf.definition)
        map('n', 'gD', vim.lsp.buf.declaration)
        map('n', 'K', vim.lsp.buf.hover)
        map('n', '<leader>rn', vim.lsp.buf.rename)
        map('n', '<leader>ca', vim.lsp.buf.code_action)
      end

      require('mason').setup()

      -- Lua
      vim.lsp.config('lua_ls', {
        capabilities = lsp_capabilities(),
        on_attach = on_attach,
        settings = {
          Lua = {
            diagnostics = { globals = { 'vim' } },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      })
      vim.lsp.enable 'lua_ls'

      -- ESLint: validate only, no formatting; autofix on save handled below
      vim.lsp.config('eslint', {
        capabilities = lsp_capabilities(),
        on_attach = on_attach,
        settings = {
          format = false,
          validate = 'on',
        },
      })
      vim.lsp.enable 'eslint'

      -- ESLint autofix on save
      -- Uses the LspEslintFixAll command provided by the eslint server.
      -- Runs before conform's BufWritePre, so prettier/biome formats afterwards.
      local eslint_fix_group = vim.api.nvim_create_augroup('EslintFixOnSave', { clear = true })
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = eslint_fix_group,
        pattern = { '*.js', '*.jsx', '*.ts', '*.tsx', '*.mjs', '*.cjs' },
        callback = function(args)
          -- Only run if an eslint client is attached to this buffer
          local clients = vim.lsp.get_clients { bufnr = args.buf, name = 'eslint' }
          if #clients > 0 then
            vim.cmd 'silent! LspEslintFixAll'
          end
        end,
      })

      -- TypeScript / JavaScript language server
      vim.lsp.config('ts_ls', {
        capabilities = lsp_capabilities(),
        on_attach = on_attach,
        single_file_support = false,
        init_options = {
          hostInfo = 'neovim',
        },
      })
      vim.lsp.enable 'ts_ls'

      -- Swift
      vim.lsp.config('sourcekit', {
        capabilities = lsp_capabilities(),
        on_attach = on_attach,
      })
      vim.lsp.enable 'sourcekit'
    end,
  },
}
