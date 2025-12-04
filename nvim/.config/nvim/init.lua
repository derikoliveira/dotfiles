vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.number = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.termguicolors = true
vim.o.signcolumn = 'yes'

-- LSP
vim.lsp.config['lua-lsp'] = {
    cmd = { '~/.luarocks/bin/lua-lsp' },
    filetypes = { 'lua' }
}
vim.lsp.enable('lua-lsp')

vim.lsp.config['zls'] = {
	cmd = { 'zls' },
	filetypes = { 'zig' }
}
vim.lsp.enable('zls')

-- Plugins
vim.pack.add({
	{src = "https://github.com/nvim-lua/plenary.nvim"},
	{src = "https://github.com/stevearc/oil.nvim"},
	{src = "https://github.com/nvim-telescope/telescope.nvim", version="v0.2.0"},
	{src = "https://github.com/nvim-treesitter/nvim-treesitter", version="main"},
	{src = "https://github.com/ggandor/leap.nvim"},
	{src = "https://github.com/ThePrimeagen/harpoon", version="harpoon2"},
	{src = "https://github.com/folke/which-key.nvim"},
	{src = "https://github.com/kylechui/nvim-surround"},
	{src = "https://github.com/stevearc/conform.nvim"}, -- TODO: config
})

require("nvim-surround").setup()
require("oil").setup()
local harpoon = require("harpoon")
harpoon:setup()

-- Keymaps
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map({'n', 'v'}, '<Leader>y', '"+y')
map({'n', 'v'}, '<Leader>Y', '"+Y')
map('n', '<Leader>p', '"+p')
map('n', '<Leader>P', '"+P')
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

local builtin = require('telescope.builtin')
map('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
map('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
map('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
map('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

map({ 'n', 'x', 'o' }, 's', '<Plug>(leap)')
map('n', 'S', '<Plug>(leap-from-window)')

map("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

map("n", "<leader>ha", function() harpoon:list():add() end, { desc = 'Harpoon add' })
map("n", "<leader>ht", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'Harpoon toggle quick menu' })
map("n", "<leader>q", function() harpoon:list():select(1) end, { desc = 'Harpoon select 1' })
map("n", "<leader>w", function() harpoon:list():select(2) end, { desc = 'Harpoon select 2' })
map("n", "<leader>e", function() harpoon:list():select(3) end, { desc = 'Harpoon select 3' })
map("n", "<leader>r", function() harpoon:list():select(4) end, { desc = 'Harpoon select 4' })
map("n", "<leader>hp", function() harpoon:list():prev() end, { desc = 'Harppon previous' })
map("n", "<leader>hn", function() harpoon:list():next() end, { desc = 'harpoon next' })

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

