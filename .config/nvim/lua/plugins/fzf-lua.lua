return {
  'ibhagwan/fzf-lua',
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
      winopts = {
        fullscreen = false,
      },
      files = {
        prompt = 'Files❯ ',
        cmd = 'fd --type f --hidden --exclude .git --exclude node_modules --exclude dist --exclude build --no-ignore',
        git_icons = false,
        file_icons = true,
        color_icons = true,
      },
      grep = {
        prompt = 'Rg❯ ',
        input_prompt = 'Grep For❯ ',
        cmd = [[rg --column --line-number --no-heading --color=always --smart-case --hidden --glob '!.git/*' --glob '!node_modules/*']],
        git_icons = false,
        file_icons = true,
        color_icons = true,
      },
      git = {},
    }
    local fzf = require 'fzf-lua'
    vim.keymap.set('n', '<leader>sf', fzf.files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>sw', fzf.grep_cword, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', fzf.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sv', fzf.grep_visual, { desc = '[S]earch [V]isual selection' })
    vim.keymap.set('n', '<leader>sd', fzf.diagnostics_workspace, { desc = '[S]earch [D]iagnostics workspace' })
    vim.keymap.set('n', '<leader>sh', fzf.search_history, { desc = '[S]earch [H]istory' })
    vim.keymap.set('n', '<leader>st', fzf.git_status, { desc = '[S]earch git s[T]atus' })
    vim.keymap.set('n', '<leader>ca', fzf.lsp_code_actions, { desc = '[C]ode [A]ctions' })
    vim.keymap.set('n', 'gd', '<Cmd>vsplit | lua vim.lsp.buf.definition()<CR>', { desc = '[G]o to [D]efinition' })
    -- vim.keymap.set('n', 'gd', '<Cmd>vsplit | lua require("fzf-lua").lsp_definitions()<CR>', { desc = '[G]o to [D]efinition', silent = true, noremap = true })
    vim.keymap.set('n', '<leader>sd', fzf.lsp_references, { desc = '[G]o to [R]eferences' })
  end,
}
