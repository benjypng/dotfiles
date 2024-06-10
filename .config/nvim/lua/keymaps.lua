-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
-- Abbrev
vim.cmd.inoreabbrev {
  'clog',
  'console.log()<Esc>ha',
}

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Logseq Build
map('n', '<leader>B', ':terminal pnpm run build<CR>')

-- Save All
map('n', ';;', ':wall<CR>')

-- Quit
map('n', '<leader>q', ':q<CR>')

-- Close all windows and exit from Neovim with <leader> and q
map('n', '<leader>Q', ':qa!<CR>')

-- Change x so it doesn't save deleted character to history
map('n', 'x', '"_dl')

-- Make Y behave like D or C
map('n', 'Y', 'y$')

-- Keeping it centered
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')
map('n', 'J', 'mzJ`z')

-- Move to beginning or end of line without taking fingers off home row
map('n', 'H', '^')
map('n', 'L', '$')

-- Select till end of line similar without taking fingers off home row
map('v', 'H', '^')
map('v', 'L', '$')

-- Moving text
map('v', 'J', ":m '>+1<CR>gv=gv")
map('v', 'K', ":m '<-2<CR>gv=gv")
map('i', '<C-j>', '<esc>:m .+1<CR>==')
map('i', '<C-k>', '<esc>:m .-2<CR>==')
map('n', '<leader>j', ':m .+1<CR>==')
map('n', '<leader>k', ':m .-2<CR>==')

-- Replaces word under the cursor. First, change the word, then press '.' to change subsequent words
map('n', '<leader>x', "/<C-R>=expand('<cword>')<CR><CR>``cgn")

-- Find and replace text in visual mode
map('v', '<C-r>', '"hy:.,$s/<C-r>h//gc<left><left><left>')

-- Exit terminal
map('t', '<Esc>', '<C-\\><C-n><C-o>')

-- Go to terminal
map('n', '<leader>ft', ':terminal<CR>a')

-- Open netrw
map('n', '<leader>n', ':Explore<CR>')

-- Fix <C-i>
map('n', '<C-p>', '<C-I>')

-- Reload luafile
vim.keymap.set('n', '<leader>R', ':luafile %<CR>', { desc = 'Reload Luafile' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
-- vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
-- vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
-- vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
-- vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- vim: ts=2 sts=2 sw=2 et
