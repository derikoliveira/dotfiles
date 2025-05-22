-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Make line numbers default
vim.opt.number = true

-- Relative line numbers, to help with jumping
vim.opt.relativenumber = true

-- Sync clipboard between OS and Neovim
--   Schedule the setting after `UiEnter` because it can increase startup-time
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Minimal number of screen lines to keep above and below the cursos
vim.opt.scrolloff = 12
