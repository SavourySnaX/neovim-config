--[[ opts.lua ]]
local opt = vim.opt
local cmd = vim.api.nvim_command

---Context
--opt.colorcolumn = '80'
opt.scrolloff = 4

---FileTypes
opt.encoding = 'utf8'
opt.fileencoding = 'utf8'

---Theme
opt.syntax = "ON"
opt.termguicolors = true
cmd('colorscheme dracula')

---Search
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = false

---Whitespace
opt.expandtab = true
opt.shiftwidth = 4
opt.softtabstop = 4
opt.tabstop = 4

---Splits
opt.splitright = true
opt.splitbelow = true
