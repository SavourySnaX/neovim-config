-- [[ plug.lua ]]

return require('packer').startup({function(use)
    -- plugins here
    use {
        'wbthomason/packer.nvim'
    }
    use {
        'kyazdani42/nvim-tree.lua',
        requires = 'kyazdani42/nvim-web-devicons'
    }

    -- theme
    use { 'goolord/alpha-nvim',                 -- start screen
        requires = {'kyazdani42/nvim-web-devicons'},
        config = function()
            require'alpha'.setup(require'alpha.themes.startify'.opts)
            local startify = require("alpha.themes.startify")
            startify.section.bottom_buttons.val = {
                startify.button("v", "neovim config",
                    ":e ~/.config/nvim/init.lua<CR>"),
                startify.button("q", "quit nvim", ":qa<CR>"),
            }
        end
    }
    use {
        'nvim-lualine/lualine.nvim',            -- statusline
        requires = {'kyazdani42/nvim-web-devicons',
            opt = true}
    }
    use { 'Mofiqul/dracula.nvim' }              -- colorscheme
    use { 'tpope/vim-fugitive' }                -- git integration
    use { 'junegunn/gv.vim' }                   -- commit history
    use { 'williamboman/mason.nvim' }           -- manage LSP
    use { 'williamboman/mason-lspconfig.nvim' } -- manage launching LSP
    use { 'neovim/nvim-lspconfig' }             -- launch lsp
    use { 'liuchengxu/vista.vim' }              -- outliner
    use { 'theHamsta/nvim-semantic-tokens' }    -- semantic highlight

    use {                                       -- find all the things
        'nvim-telescope/telescope.nvim',
        tag = '0.1.0',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    use { 'onsails/lspkind.nvim' }              -- LSP icons

    use { 'L3MON4D3/LuaSnip' }                  -- Lua Snippets
    use { 'saadparwaiz1/cmp_luasnip' }          -- Lua Snip for Completion Engine

    use { 'hrsh7th/cmp-nvim-lsp' }                  -- LSP auto complete
    use { 'hrsh7th/cmp-nvim-lsp-signature-help' }   -- LSP auto complete for signatures
    use { 'hrsh7th/cmp-buffer' }                    -- buffer auto complete
    use { 'hrsh7th/cmp-path' }                      -- path auto complete
    use { 'hrsh7th/nvim-cmp' }                      -- Completion engine

    use { 'mfussenegger/nvim-dap' }             -- debug adapters
    use { 'rcarriga/nvim-dap-ui', requires = { 'mfussenegger/nvim-dap'}}
end,
config = {
    package_root = vim.fn.stdpath('config') .. '/site/pack'
}})

