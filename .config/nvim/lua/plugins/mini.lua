return {
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      require('mini.pairs').setup()

      require('mini.completion').setup {
        delay = { completion = 150, info = 200, signature = 250 },
        window = { info = {}, signature = {} },
        lsp_completion = {
          source_func = 'omnifunc',
          auto_setup = true,
        },
        mappings = {
          force_twostep = '<C-Space>',
          force_fallback = '<C-f>',
        },
      }
      require('mini.snippets').setup {}
      local imap_expr = function(lhs, rhs)
        vim.keymap.set('i', lhs, rhs, { expr = true })
      end
      imap_expr('<Tab>', [[pumvisible() ? "\<C-n>" : "\<Tab>"]])
      imap_expr('<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]])

      -- Handle Enter
      local keycode = vim.keycode or function(x)
        return vim.api.nvim_replace_termcodes(x, true, true, true)
      end
      local keys = {
        ['cr'] = keycode '<CR>',
        ['ctrl-y'] = keycode '<C-y>',
        ['ctrl-y_cr'] = keycode '<C-y><CR>',
      }

      _G.cr_action = function()
        if vim.fn.pumvisible() ~= 0 then
          local item_selected = vim.fn.complete_info()['selected'] ~= -1
          return item_selected and keys['ctrl-y'] or keys['ctrl-y_cr']
        else
          return keys['cr']
        end
      end

      vim.keymap.set('i', '<CR>', 'v:lua._G.cr_action()', { expr = true, noremap = true, silent = true })

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
