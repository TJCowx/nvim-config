-- ================================================
-- 		VSCODE DISABLE KEYMAPS
-- ================================================
if not vim.g.vscode then
  -- Minimal number of screen lines to keep above and below the cursor.
  vim.opt.scrolloff = 999 
end
-- ================================================
-- 		BASIC KEYMAPS
-- ================================================
-- SET LEADER KEY
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- TODO: Actually set this
-- Configurations that break VSCode


vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Use system clipboard
vim.opt.clipboard = 'unnamedplus'

-- Save undo history
vim.opt.undofile = true

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- ================================================
-- 		NVIM.LAZY INIT
-- ================================================
-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- ================================================
-- 		PLUGINS SETUP
-- ================================================
require('lazy').setup({
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  -- ================================================
  --		  GIT PLUGINS
  -- ================================================
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
	add = { text = '+' },
	change = { text = '~' },
	delete = { text = '_' },
	topdelete = { text = '‾' },
	changedelete = { text = '~' },
      },
    },
  },
  -- ================================================
  -- 		THEMING PLUGINS
  -- ================================================
  { -- Used for dark theme
    "olimorris/onedarkpro.nvim",
    priority = 1000, -- Ensure it loads first
    config = function()
      isDark = true
      vim.cmd("colorscheme onedark")
    end
  },
  { -- Used for light theme
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  { -- Highlight todo, notes, etc in comments
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false }
  },
  -- ================================================
  -- 	      PRODUCTIVITY PLUGINS
  -- ================================================
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = { 
        'bash',
        'c',
        'css',
        'graphql',
        'html',
        'javascript',
        'lua',
        'luadoc',
        'markdown',
        'python',
        'rust',
        'tsx',
        'typescript',
        'vim',
        'vimdoc'
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
      },
      indent = { enable = true },
    },
    config = function(_, opts)
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

      -- Prefer git instead of curl in order to improve connectivity in some environments
      require('nvim-treesitter.install').prefer_git = true
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup(opts)

      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    end,
  },
})

-- ================================================
-- 		PLUGINS CONFIG
-- ================================================
vim.keymap.set('n', '<Leader>tt', function() 
  if isDark then
    isDark = false
    vim.cmd("colorscheme tokyonight-day")
  else
    isDark = true
    vim.cmd("colorscheme onedark")
  end
end)
