local utils = require 'config.utils'

vim.keymap.set('n', '<C-k>', function()
  utils.delete_blank_line_relative 'above'
end, { noremap = true, silent = true, desc = 'Delete blank line above' })

vim.keymap.set('n', '<C-j>', function()
  utils.delete_blank_line_relative 'below'
end, { noremap = true, silent = true, desc = 'Delete blank line below' })

vim.keymap.set('n', '<A-k>', function()
  utils.create_blank_line_relative 'above'
end, { noremap = true, silent = true, desc = 'Insert blank line above' })

vim.keymap.set('n', '<A-j>', function()
  utils.create_blank_line_relative 'below'
end, { noremap = true, silent = true, desc = 'Insert blank line below' })
