-- [init.lua]

vim.g.mapleader = ","
vim.g.localleader = "\\"

--- IMPORTS

require('vars')
require('opts')
require('keys')
require('plug')

-- Debugging
--vim.lsp.set_log_level('debug')

-- for humphrey
vim.cmd [[ autocmd BufNewFile,BufRead *.humphrey set filetype=humphrey ]]
require('nvim-web-devicons').setup {
    override = {

        ['humphrey'] = {
            icon = "🧸",

            name = "Humphrey",
        }
    }
}

local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
parser_config.humphrey = {
    install_info = {
        url = "https://github.com/SavourySnaX/tree-sitter-humphrey.git",
        files = {"src/parser.c","src/scanner.c"},

        branch="main",
        generate_requires_npm=true,
        requires_generate_from_grammar=true
    },
    filetype="humphrey",
}


local lspconfigs = require('lspconfig.configs')
local lspconfig = require('lspconfig')
if not lspconfigs.humphrey then
    lspconfigs.humphrey = {
        default_config = {
            cmd = { 'HumphreyLanguageServer' },
            filetypes = { 'humphrey' },
            root_dir = lspconfig.util.root_pattern('humphrey.json', '.git'),
        },
    }
end

-- PLUGINS
require('nvim-treesitter.configs').setup {
    playground= {
        enable = true
    }
}

require('nvim-tree').setup{}
require('lualine').setup{
    options = {
        theme = 'dracula-nvim'
    }
}
require('mason').setup{}
require('mason-lspconfig').setup{}

require("nvim-semantic-tokens").setup {
  preset = "default",
  -- highlighters is a list of modules following the interface of nvim-semantic-tokens.table-highlighter or 
  -- function with the signature: highlight_token(ctx, token, highlight) where 
  --        ctx (as defined in :h lsp-handler)
  --        token  (as defined in :h vim.ls p.semantic_tokens.on_full())
  --        highlight (a helper function that you can call (also multiple times) with the determined highlight group(s) as the only parameter)
  highlighters = { require 'nvim-semantic-tokens.table-highlighter'}
}

local capabilities = require('cmp_nvim_lsp').default_capabilities()

require('lspconfig').omnisharp.setup{}
require('lspconfig').sumneko_lua.setup{}
require('lspconfig').csharp_ls.setup{}
require('lspconfig').humphrey.setup{
    capabilities = capabilities,
    on_attach = function(client, bufnr)
        vim.keymap.set("n","K", vim.lsp.buf.hover, {buffer=0})
        vim.keymap.set("n","gd", vim.lsp.buf.definition, {buffer=0})
        vim.keymap.set("n","<Leader>dl", "<cmd>Telescope diagnostics<CR>", {buffer=0})
        local caps = client.server_capabilities
        if caps.semanticTokensProvider and caps.semanticTokensProvider.full then
            local augroup = vim.api.nvim_create_augroup('SemanticTokens', {})
            vim.api.nvim_create_autocmd("TextChanged", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.semantic_tokens_full()
                end,
            })
            vim.lsp.buf.semantic_tokens_full()
        end
    end,
}

-- Colours for LSP
vim.cmd('hi! LspFunction guibg=NONE guifg=#DCDCAA')
vim.cmd('hi! LspKeyword guibg=NONE guifg=#C586C0')
vim.cmd('hi! LspRegExp guibg=NONE guifg=#646695')
vim.cmd('hi! LspParameter guibg=NONE guifg=#9CDCFE')
vim.cmd('hi! LspOperator guibg=NONE guifg=#D4D4D4')
vim.cmd('hi! LspType guibg=NONE guifg=#4EC9B0')
vim.cmd('hi! LspVariable guibg=NONE guifg=#3CACCE')
vim.cmd('hi! LspStruct guibg=NONE guifg=#1E9980')
vim.cmd('hi! LspNumber guibg=NONE guifg=#B5CEA8')
vim.cmd('hi! LspString guibg=NONE guifg=#CE9178')
vim.cmd('hi! LspEnumMember guibg=NONE guifg=#4FC1FF')
vim.cmd('hi! LspComment guibg=NONE guifg=#6A9955')
vim.cmd('hi! LspEnum guibg=NONE guifg=#3EB9A0')
vim.cmd('hi! LspProperty guibg=NONE guifg=#ACECFE')

-- Auto completion

  vim.opt.completeopt={"menu","menuone","noselect"}

  -- Set up nvim-cmp.
  local cmp = require'cmp'
  local lspkind = require'lspkind'
  cmp.setup({
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    formatting = {
        format = lspkind.cmp_format
        {
            mode = 'symbol_text',
            menu = {
                nvim_lsp = "[LSP]",
                buffer = "[buf]",
                path = "[path]",
                luasnip = "[snip]",
            },
        },
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'nvim_lsp_signature_help' },
      { name = 'luasnip' }, -- For luasnip users.
    }, {
      { name = 'buffer' },
    }
    )
  })

  cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
          { name = 'path' }
      }, {
          { name = 'cmdline' }
      })
  })

-- Compile 

vim.opt.errorformat = '%f:%l:%c:%*[\\ ]%t%*[^:]:%m,%E%>Error%*[^:]:%m,%C%*[^-]-->%*[\\ ]\\"%f\\"@%l:%c,%Z'
vim.opt.makeprg = 'ninja'
vim.keymap.set("n", "<C-b>", "<cmd>make<CR>")


-- DAP

require('nvim-dap-virtual-text').setup()

local dap = require('dap')
dap.adapters.lldb = {
    type = 'executable',
    command = '/usr/bin/lldb-vscode-14',
    name = 'lldb'
}

dap.configurations.humphrey = {
    {
        name = 'Launch',
        type = 'lldb',
        request = 'launch',
        program = function()
            local myVal = 1
            vim.ui.select({'Compiler','Tests'},{
                prompt = 'Select Executable'},function(choice)
                    myVal = choice
                end)
            if ( myVal == 'Compiler') then
                return vim.fn.getcwd().."/.out/compiler"
            else
                return vim.fn.getcwd().."/.out/tests"
            end
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry=false,
        args = {"debug_entry.humphrey","--threads","1","--add","external/Humphrey.System","--add","src/humphreyFiles"},
        runInTerminal = false,
    },
}

vim.keymap.set("n", "<F9>", "<cmd>lua require'dap'.toggle_breakpoint()<CR>")
vim.keymap.set("n", "<F5>", "<cmd>lua require'dap'.continue()<CR>")
vim.keymap.set("n", "<F8>", "<cmd>lua require'dap'.step_over()<CR>")
vim.keymap.set("n", "<F7>", "<cmd>lua require'dap'.step_into()<CR>")
vim.keymap.set("n", "<F12>", "<cmd>lua require'dap'.step_out()<CR>")
vim.keymap.set("n", "<F2>", "<cmd>lua require'dapui'.toggle()<CR>")

require("dapui").setup({
  icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  -- Expand lines larger than the window
  -- Requires >= 0.7
  expand_lines = vim.fn.has("nvim-0.7") == 1,
  -- Layouts define sections of the screen to place windows.
  -- The position can be "left", "right", "top" or "bottom".
  -- The size specifies the height/width depending on position. It can be an Int
  -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
  -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
  -- Elements are the elements shown in the layout (in order).
  -- Layouts are opened in order so that earlier layouts take priority in window sizing.
  layouts = {
    {
      elements = {
      -- Elements can be strings or table with id and size keys.
        { id = "scopes", size = 0.25 },
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 80, -- 40 columns
      position = "left",
    },
    {
      elements = {
        "repl",
        "console",
      },
      size = 0.25, -- 25% of total lines
      position = "bottom",
    },
  },
  controls = {
    -- Requires Neovim nightly (or 0.8 when released)
    enabled = true,
    -- Display controls in this element
    element = "repl",
    icons = {
      pause = "",
      play = "",
      step_into = "",
      step_over = "",
      step_out = "",
      step_back = "",
      run_last = "↻",
      terminate = "□",
    },
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = "single", -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil, -- Can be integer or nil.
    max_value_lines = 100, -- Can be integer or nil.
  }
})
