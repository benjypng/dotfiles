-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local discipline = require("custom.discipline")

discipline.cowboy()

-- Build Logseq plugin
map("n", "<leader>B", ":!pnpm run build<CR>")

-- Fast saving
map("n", ";;", ":w<CR>")

-- Quit
map("n", "<leader>q", ":q<CR>")

-- Close all windows and exit from Neovim with <leader> and q
map("n", "<leader>Q", ":qa!<CR>")

-- Change x so it doesn't save deleted character to history
map("n", "x", '"_dl')

-- Make Y behave like D or C
map("n", "Y", "y$")

-- Keeping it centered
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "J", "mzJ`z")

-- Move to beginning or end of line without taking fingers off home row
map("n", "H", "^")
map("n", "L", "$")

-- Moving text
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")
map("i", "<C-j>", "<esc>:m .+1<CR>==")
map("i", "<C-k>", "<esc>:m .-2<CR>==")
map("n", "<leader>j", ":m .+1<CR>==")
map("n", "<leader>k", ":m .-2<CR>==")

-- Replaces word under the cursor. First, change the word, then press '.' to change subsequent words
map("n", "<leader>x", "/<C-R>=expand('<cword>')<CR><CR>``cgn")

-- Find and replace text in visual mode
map("v", "<C-r>", '"hy:.,$s/<C-r>h//gc<left><left><left>')
