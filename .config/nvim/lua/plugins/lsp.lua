-- lua/plugins/lsp.lua
return {
  { 'williamboman/mason.nvim', opts = {} },

  {
    'neovim/nvim-lspconfig',
    -- event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'williamboman/mason.nvim',
      -- REMOVE: 'pmizio/typescript-tools.nvim',
      -- Completion stack (assuming you switched to nvim-cmp)
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
    config = function()
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

      -- Capabilities (inform servers we support cmp completion)
      local function lsp_capabilities()
        local caps = vim.lsp.protocol.make_client_capabilities()
        return require('cmp_nvim_lsp').default_capabilities(caps)
      end

      -- on_attach: keep your maps, disable LSP formatting
      local function on_attach(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false

        local map = function(mode, lhs, rhs)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr })
        end

        map('n', 'gd', function()
          vim.cmd 'vsplit'
          vim.lsp.buf.definition()
        end)

        -- gD: prefer type definition if declaration is missing
        map('n', 'gD', function()
          vim.cmd 'vsplit'
          vim.lsp.buf.declaration()
        end)

        map('n', 'K', vim.lsp.buf.hover)
        map('n', '<leader>rn', vim.lsp.buf.rename)
        map({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action)
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

      -- ESLint (keep formatting off)
      vim.lsp.config('eslint', {
        settings = { format = false, validate = 'on' },
        capabilities = lsp_capabilities(),
        on_attach = on_attach,
      })
      vim.lsp.enable 'eslint'

      -- 🔁 Plain TSSERVER (via typescript-language-server)
      local util = require 'lspconfig.util'
      vim.lsp.config('ts_ls', {
        capabilities = lsp_capabilities(),
        on_attach = on_attach,
        -- Keep tsserver out of Deno projects; prefer Node/React here
        root_dir = util.root_pattern('package.json', 'tsconfig.json', 'jsconfig.json', '.git'),
        single_file_support = false,
        init_options = {
          hostInfo = 'neovim',
          -- preferences = { includeInlayParameterNameHints = 'all' }, -- optional
        },
      })
      vim.lsp.enable 'ts_ls'
    end,
  },
}
