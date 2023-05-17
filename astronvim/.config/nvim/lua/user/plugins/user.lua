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
    'ruifm/gitlinker.nvim',
    lazy = false,
    config = function()
      require "gitlinker".setup()
    end
  },
  { 'github/copilot.vim',             event = "BufRead" },
  { 'ntpeters/vim-better-whitespace', event = "BufRead" },
  { "mg979/vim-visual-multi",         event = "VeryLazy", },
  {
    "MaximilianLloyd/ascii.nvim",
    lazy = false,
    dependencies = {
      "MunifTanjim/nui.nvim"
    }
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { -- add a new dependency to telescope that is our new plugin
      "nvim-telescope/telescope-media-files.nvim",
      {
        "nvim-telescope/telescope-frecency.nvim",
        dependencies = { "kkharji/sqlite.lua" }
      },
      "LukasPietzschmann/telescope-tabs",
      {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
      }
    },
    -- the first parameter is the plugin specification
    -- the second is the table of options as set up in Lazy with the `opts` key
    config = function(plugin, opts)
      -- run the core AstroNvim configuration function with the options table
      require("plugins.configs.telescope")(plugin, opts)

      -- require telescope and load extensions as necessary
      local telescope = require "telescope"
      telescope.load_extension "media_files"
      telescope.load_extension "frecency"
      telescope.load_extension "file_browser"
      require 'telescope-tabs'.setup {
        -- Your custom config :^)
      }

      telescope.setup {
        defaults = {
          preview = {
            filesize_hook = function(filepath, bufnr, opts)
              local max_bytes = 10000
              local cmd = { "head", "-c", max_bytes, filepath }
              require('telescope.previewers.utils').job_maker(cmd, bufnr, opts)
            end
          }
        }
      }
    end,
  },
  { 'sindrets/diffview.nvim',         event = "VeryLazy", dependencies = 'nvim-lua/plenary.nvim' },
  {
    'preservim/vim-markdown',
    event = "VeryLazy",
    dependencies = {
      'godlygeek/tabular'
    }
  },
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    config = function()
      require("transparent").setup({
      })
    end,
  },
  {
    "wakatime/vim-wakatime",
    lazy = false,
  },
  { "mrjones2014/smart-splits.nvim",  event = "VeryLazy" },
  { "wintermute-cell/gitignore.nvim", event = "VeryLazy" },
  { "tpope/vim-fugitive",             event = "VeryLazy" }
}
