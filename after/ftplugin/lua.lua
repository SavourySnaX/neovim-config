local loc = vim.opt_local
loc.suffixesadd:prepend('.lua')
loc.suffixesadd:prepend('init.lua')
loc.path:prepend(vim.fn.stdpath('config') .. '/lua')
