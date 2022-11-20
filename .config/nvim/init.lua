-- defaults
local scopes = {o = vim.o, b = vim.bo, w = vim.wo}

local function opt(scope, key, value) scopes[scope][key] = value
  if scope ~= 'o' then scopes['o'][key] = value end
end

vim.g.mapleader = ","
local indent = 2
opt('b', 'expandtab', true)                           -- Use spaces instead of tabs
opt('b', 'shiftwidth', indent)                        -- Size of an indent
opt('b', 'smartindent', true)                         -- Insert indents automatically
opt('b', 'tabstop', indent)                           -- Number of spaces tabs count for
opt('o', 'completeopt', 'menuone,noinsert,noselect')  -- Completion options (for deoplete)
opt('o', 'completeopt', "menuone,noselect");
opt('o', 'hidden', true)                              -- Enable modified buffers in background
opt('o', 'clipboard', 'unnamedplus')

opt('o', 'ignorecase', true)                          -- Ignore case
opt('o', 'joinspaces', false)                         -- No double spaces with join after a dot
opt('o', 'scrolloff', 4 )                             -- Lines of context
opt('o', 'shiftround', true)                          -- Round indent
opt('o', 'sidescrolloff', 8 )                         -- Columns of context
opt('o', 'smartcase', true)                           -- Don't ignore case with capitals
opt('o', 'splitbelow', true)                          -- Put new windows below current
opt('o', 'splitright', true)                          -- Put new windows right of current
opt('o', 'termguicolors', true)                       -- True color support
opt('o', 'wildmode', 'list:longest')                  -- Command-line completion mode
opt('w', 'list', true)                                -- Show some invisible characters (tabs...)
opt('w', 'number', true)                              -- Print line number
opt('w', 'relativenumber', true)                      -- Relative line numbers
opt('w', 'wrap', false)                               -- Disable line wrap

vim.g.nvim_tree_gitignore = 1;                        -- ignore files in tree that are ignored by git
vim.opt.mouse = 'a'

require "paq" {
  "savq/paq-nvim";                  -- Let Paq manage itself
  "neovim/nvim-lspconfig";

  "hkupty/iron.nvim";

  "hrsh7th/nvim-compe";

  'tpope/vim-commentary';
  'tpope/vim-surround';
  -- 'nvim-treesitter/nvim-treesitter';
  -- 'nvim-treesitter/playground';
  'ojroques/nvim-lspfuzzy';
  'kassio/neoterm';
  'yamatsum/nvim-nonicons';
  'kyazdani42/nvim-tree.lua';
  'kyazdani42/nvim-web-devicons';

  'joshdick/onedark.vim';
  'pineapplegiant/spaceduck';
  'tpope/vim-unimpaired';
  'tpope/vim-repeat';
  'tpope/vim-fugitive';
  'mg979/vim-visual-multi';


  'hrsh7th/nvim-compe';

  --Deps for telescope
  'nvim-lua/popup.nvim';
  'nvim-lua/plenary.nvim';
  'nvim-telescope/telescope.nvim';
  'mfussenegger/nvim-dap';
  'rcarriga/nvim-dap-ui';
  {'junegunn/fzf', run = vim.fn['fzf#install']};
  'neomake/neomake';
}

require'nvim-tree'.setup {} 
-- local ts = require 'nvim-treesitter.configs'
-- ts.setup {ensure_installed = 'maintained', highlight = {enable = true}}
require("dapui").setup()
local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- require'lspconfig'.pyright.setup{}
-- require'lspconfig'.tsserver.setup{}
-- require'lspconfig'.jdtls.setup{}


map('', '<leader>c', '"+y')       -- Copy to clipboard in normal, visual, select and operator modes
map('i', '<C-u>', '<C-g>u<C-u>')  -- Make <C-u> undo-friendly
map('i', '<C-w>', '<C-g>u<C-w>')  -- Make <C-w> undo-friendly

-- <Tab> to navigate the completion menu
map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {expr = true})
map('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})

map('n', '<C-l>', '<cmd>noh<CR>')    -- Clear highlights
map('n', '<leader>o', 'm`o<Esc>``')  -- Insert a newline in normal mode

local lsp = require 'lspconfig'

map('n', '<space>,', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
map('n', '<space>;', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
map('n', '<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>')
map('n', '<space>d', '<cmd>lua vim.lsp.buf.definition()<CR>')
map('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')
map('n', '<space>h', '<cmd>lua vim.lsp.buf.hover()<CR>')
map('n', '<space>m', '<cmd>lua vim.lsp.buf.rename()<CR>')
map('n', '<space>r', '<cmd>lua vim.lsp.buf.references()<CR>')
map('n', '<space>s', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')

map('n', '<Leader>g',  [[<Cmd>lua require('telescope.builtin').live_grep()<CR>]], { noremap = true, silent = true })
map('n', '<Leader>f',  [[<Cmd>lua require('telescope.builtin').find_files()<CR>]], { noremap = true, silent = true })
map('n', '<Leader>b',  [[<Cmd>lua require('telescope.builtin').buffers()<CR>]], { noremap = true, silent = true })
map('n', '<Leader>gf',  [[<Cmd>lua require('telescope.builtin').git_files()<CR>]], { noremap = true, silent = true })
map('n', '<Leader>gc',  [[<Cmd>lua require('telescope.builtin').git_commits()<CR>]], { noremap = true, silent = true })
map('n', '<Leader>t',  [[<Cmd>lua require('telescope.builtin').git_commits()<CR>]], { noremap = true, silent = true })


map('n', '<leader>n', ':NvimTreeToggle<CR>')
map('n', '<leader>r', ':NvimTreeRefresh<CR>')

map('n', '<C-k>', '[[<cmd>lua vim.lsp.buf.type_definition()<CR>]]')

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
    ultisnips = true;
  };
}

local dap = require('dap')

dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  args = {os.getenv('HOME') .. '/src/microsoft/vscode-node-debug2/out/src/nodeDebug.js'},
}
dap.configurations.javascript = {
  {
    type = 'node2',
    request = 'launch',
    program = '${workspaceFolder}/${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
  },
}


vim.cmd 'colorscheme onedark'                         -- Put your favorite colorscheme here

local iron = require("iron.core")

iron.setup {
  config = {
    -- Whether a repl should be discarded or not
    scratch_repl = true,
    -- Your repl definitions come here
    repl_definition = {
      sh = {
        -- Can be a table or a function that
        -- returns a table (see below)
        command = {"zsh"}
      }
    },
    -- How the repl window will be displayed
    -- See below for more information
    repl_open_cmd = require('iron.view').bottom(40),
  },
  -- Iron doesn't set keymaps by default anymore.
  -- You can set them here or manually add keymaps to the functions in iron.core
  keymaps = {
    send_motion = "<space>sc",
    visual_send = "<space>sc",
    send_file = "<space>sf",
    send_line = "<space>sl",
    send_mark = "<space>sm",
    mark_motion = "<space>mc",
    mark_visual = "<space>mc",
    remove_mark = "<space>md",
    cr = "<space>s<cr>",
    interrupt = "<space>s<space>",
    exit = "<space>sq",
    clear = "<space>cl",
  },
  -- If the highlight is on, you can change how it looks
  -- For the available options, check nvim_set_hl
  highlight = {
    italic = true
  },
  ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
}

-- iron also has a list of commands, see :h iron-commands for all available commands
vim.keymap.set('n', '<space>rs', '<cmd>IronRepl<cr>')
vim.keymap.set('n', '<space>rr', '<cmd>IronRestart<cr>')
vim.keymap.set('n', '<space>rf', '<cmd>IronFocus<cr>')
vim.keymap.set('n', '<space>rh', '<cmd>IronHide<cr>')
