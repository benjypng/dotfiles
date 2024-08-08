return {
  'ibhagwan/fzf-lua',
  -- optional for icon support
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('fzf-lua').setup {
      keymap = {
        fzf = {
          ['tab'] = 'down',
          ['shift-tab'] = 'up',
          ['enter'] = 'accept',
        },
      },
      files = {
        prompt = 'Files❯ ',
        cmd = "rg --files --hidden --glob '!.git/*' --glob '!node_modules/*'", -- Custom rg command
        git_icons = true, -- show git icons?
        file_icons = true, -- show file icons?
        color_icons = true, -- colorize file|git icons
      },
      grep = {
        prompt = 'Rg❯ ',
        input_prompt = 'Grep For❯ ',
        cmd = "rg --vimgrep --hidden --glob '!.git/*' --glob '!node_modules/*'", -- Custom rg command
        git_icons = true, -- show git icons?
        file_icons = true, -- show file icons?
        color_icons = true, -- colorize file|git icons
      },
    }
    local fzf = require 'fzf-lua'
    vim.keymap.set('n', '<leader>sf', fzf.files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>sw', fzf.grep_cword, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', fzf.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sv', fzf.grep_visual, { desc = '[S]earch [V]isual selection' })
    vim.keymap.set('n', '<leader>sd', fzf.diagnostics_workspace, { desc = '[S]earch [D]iagnostics workspace' })
    vim.keymap.set('n', '<leader>sh', fzf.search_history, { desc = '[S]earch [H]istory' })
  end,
}
