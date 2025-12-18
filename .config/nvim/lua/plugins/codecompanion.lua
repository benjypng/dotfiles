local secrets = require 'secrets'
vim.env.GEMINI_API_KEY = secrets.GEMINI_API_KEY

return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  keys = {
    {
      '<leader>cc',
      '<cmd>CodeCompanionChat<CR>',
      desc = 'Open CodeCompanion Chat',
    },
  },
  opts = {
    adapters = {
      http = {
        opts = {
          show_model_choices = false,
        },
        gemini = function()
          return require('codecompanion.adapters').extend('gemini', {
            schema = {
              model = {
                default = 'gemini-2.5-flash',
                choices = {
                  'gemini-2.5-flash',
                  'gemini-2.5-pro',
                },
              },
            },
          })
        end,
      },
    },

    strategies = {
      chat = { adapter = 'gemini' },
      inline = { adapter = 'gemini' },
    },

    display = {
      chat = {
        show_settings = true,
        show_header_separator = true,
        render_headers = true,
      },
    },
  },
}
