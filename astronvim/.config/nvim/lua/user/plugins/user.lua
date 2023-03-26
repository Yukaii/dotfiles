return {
  -- You can also add new plugins here as well:
  -- Add plugins, the lazy syntax
  -- "andweeb/presence.nvim",
  -- {
  --   "ray-x/lsp_signature.nvim",
  --   event = "BufRead",
  --   config = function()
  --     require("lsp_signature").setup()
  --   end,
  -- },
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    config = function()
      require('kanagawa').setup({})
    end
  },
  {
    'ruifm/gitlinker.nvim',
    lazy = false,
    config = function()
      require "gitlinker".setup()
    end
  },
  { 'github/copilot.vim',             lazy = false },
  { 'ntpeters/vim-better-whitespace', lazy = false },
  { 'imsnif/kdl.vim',                 lazy = false },
  {
    "folke/zen-mode.nvim",
    lazy = false,
    config = function()
      require("zen-mode").setup {
        window = {
          backdrop = 0.95,
          width = .65,
          height = 1,
          options = {
            number = false,
            relativenumber = false,
            cursorcolumn = false,
          }
        },
        plugins = {
          options = {
            enabled = true,
            ruler = false,   -- disables the ruler text in the cmd line area
            showcmd = false, -- disables the command in the last line of the screen
          },
        },
        on_open = function(win)
          vim.cmd("IndentBlanklineDisable")
          vim.o.laststatus = 0
          vim.o.cmdheight = 1
        end,
        on_close = function(win)
          vim.cmd("IndentBlanklineEnable")
          vim.o.laststatus = 2
          vim.o.cmdheight = 0
        end
      }
    end
  },
  {
    "kylechui/nvim-surround",
    version = "*",      -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy", -- Load on specific events
    config = function()
      require("nvim-surround").setup {}
    end
  },
  { "mg979/vim-visual-multi",           event = "VeryLazy", },
  { "windwp/nvim-spectre",              event = "VeryLazy" },
  { "nyoom-engineering/oxocarbon.nvim", lazy = false },
  {
    "MaximilianLloyd/ascii.nvim",
    lazy = false,
    dependencies = {
      "MunifTanjim/nui.nvim"
    }
  },
  {
    "nvim-telescope/telescope-frecency.nvim",
    config = function()
      require "telescope".load_extension("frecency")
    end,
    event = "VeryLazy",
    dependencies = { "kkharji/sqlite.lua", event = "VeryLazy" }
  },
  { 'sindrets/diffview.nvim', event = "VeryLazy", dependencies = 'nvim-lua/plenary.nvim' }
}
