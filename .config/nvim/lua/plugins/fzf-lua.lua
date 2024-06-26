return {
  "ibhagwan/fzf-lua",
  -- optional for icon support
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    -- calling `setup` is optional for customization
    require("fzf-lua").setup({
      keymap = {
        fzf = {
          ["tab"]       = "down",
          ["shift-tab"] = "up",
          ["enter"]     = "accept",
        },
      },
      files = {
        prompt = 'Files❯ ',
        cmd = "rg --files --hidden --glob '!.git/*' --glob '!node_modules/*'", -- Custom rg command
        git_icons = true,                                                      -- show git icons?
        file_icons = true,                                                     -- show file icons?
        color_icons = true,                                                    -- colorize file|git icons
      },
      grep = {
        prompt = 'Rg❯ ',
        input_prompt = 'Grep For❯ ',
        cmd = "rg --vimgrep --hidden --glob '!.git/*' --glob '!node_modules/*'", -- Custom rg command
        git_icons = true,                                                        -- show git icons?
        file_icons = true,                                                       -- show file icons?
        color_icons = true,                                                      -- colorize file|git icons
      },
    })
    local builtin = require 'fzf-lua'
    -- vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    --vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>sf', builtin.files, { desc = '[S]earch [F]iles' })
    -- vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_cword, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    --vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    --vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    --vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    --vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = '[ ] Find existing buffers' })
  end
}
