-- Options
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.number = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.termguicolors = true
vim.o.signcolumn = "yes"

-- Plugins
vim.pack.add {
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/nvim-telescope/telescope.nvim", version = "v0.2.0" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  { src = "https://github.com/ggandor/leap.nvim" },
  { src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },
  { src = "https://github.com/folke/which-key.nvim" },
  { src = "https://github.com/kylechui/nvim-surround" },
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://codeberg.org/mfussenegger/nvim-jdtls" },
  { src = "https://github.com/rebelot/kanagawa.nvim" },
}

-- LSP
vim.lsp.config["lua_ls"] = {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" }, -- Neovim uses LuaJIT
      workspace = {
        checkThirdParty = false,
        library = vim.api.nvim_get_runtime_file("", true), -- aware of nvim runtime
      },
      diagnostics = { globals = { "vim" } }, -- no 'undefined global vim' warnings
    },
  },
}
vim.lsp.enable "lua_ls"

vim.lsp.config["zls"] = {
  cmd = { "zls" },
  filetypes = { "zig" },
}
vim.lsp.enable "zls"

vim.lsp.config["jdtls"] = {
  cmd = { "jdtls" },
  filetypes = { "java" },
}
vim.lsp.enable "jdtls"

vim.cmd.colorscheme "kanagawa"

-- Config
local map = vim.keymap.set

map({ "n", "v" }, "<Leader>y", '"+y')
map({ "n", "v" }, "<Leader>Y", '"+Y')
map("n", "<Leader>p", '"+p')
map("n", "<Leader>P", '"+P')
map("v", "<Leader>P", '"_d"+P')
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

map("i", "<C-Space>", function() vim.lsp.completion.get() end, { desc = "Trigger LSP completion" })

local builtin = require "telescope.builtin"
map("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
map("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
map("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
map("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

require("nvim-treesitter").setup {
  ensure_installed = { "lua", "zig", "java" },
}

require("oil").setup()
map("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

map({ "n", "x", "o" }, "s", "<Plug>(leap)")
map("n", "S", "<Plug>(leap-from-window)")

local harpoon = require "harpoon"
harpoon:setup()
map("n", "<leader>ha", function() harpoon:list():add() end, { desc = "Harpoon add" })
map("n", "<leader>ht", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon toggle quick menu" })
map("n", "<leader>q", function() harpoon:list():select(1) end, { desc = "Harpoon select 1" })
map("n", "<leader>w", function() harpoon:list():select(2) end, { desc = "Harpoon select 2" })
map("n", "<leader>e", function() harpoon:list():select(3) end, { desc = "Harpoon select 3" })
map("n", "<leader>r", function() harpoon:list():select(4) end, { desc = "Harpoon select 4" })
map("n", "<leader>hp", function() harpoon:list():prev() end, { desc = "Harpoon previous" })
map("n", "<leader>hn", function() harpoon:list():next() end, { desc = "Harpoon next" })

require("nvim-surround").setup()

require("conform").setup {
  formatters = {
    clang_format = { prepend_args = { "--style={BasedOnStyle: LLVM, Language: Java, ColumnLimit: 120, IndentWidth: 4}" } },
  },
  formatters_by_ft = {
    lua = { "stylua" },
    java = { "clang_format" },
  },
}
map("n", "<leader>cf", function() require("conform").format() end, { desc = "Format file" })

-- Autocmds
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function() vim.highlight.on_yank() end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "Enable LSP completion",
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client:supports_method "textDocument/completion" then vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = false }) end
  end,
})

