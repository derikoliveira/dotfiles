vim.lsp.config['lua-lsp'] = {
    cmd = { '~/.luarocks/bin/lua-lsp' },
    filetypes = { 'lua' }
}
vim.lsp.enable('lua-lsp')

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.number = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.termguicolors = true

vim.pack.add({
    { src = 'https://github.com/ggandor/leap.nvim' }
})

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", "g.", "g;", opts)
map({ "n", "v" }, "gl", "$", opts)
map({ "n", "v" }, "gh", "0", opts)
map({ "n", "v" }, "gs", "^", opts)

map({ "n", "v" }, "<leader>y", '"+y', opts)
map({ "n", "v" }, "<leader>p", '"+p', opts)

map('t', '<Esc>', '<C-\\><C-n>', opts)

map({ 'n', 'x', 'o' }, 's', '<Plug>(leap)')
map('n', 'S', '<Plug>(leap-from-window)')
