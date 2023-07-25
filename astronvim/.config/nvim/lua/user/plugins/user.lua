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
  -- { 'github/copilot.vim',             event = "BufRead" },
  { 'ntpeters/vim-better-whitespace', event = "BufRead" },
  { "mg979/vim-visual-multi",         event = "VeryLazy", },
  {
    "MaximilianLloyd/ascii.nvim",
    lazy = false,
    dependencies = {
      "MunifTanjim/nui.nvim"
    },
    commit = "f4d165c"
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
    "wakatime/vim-wakatime",
    lazy = false,
  },
  { "mrjones2014/smart-splits.nvim",  event = "VeryLazy" },
  { "wintermute-cell/gitignore.nvim", event = "VeryLazy" },
  { "tpope/vim-fugitive",             event = "VeryLazy" },
  {
    "stevearc/oil.nvim",
    event = "VeryLazy",
  },
  {
    "Bryley/neoai.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    cmd = {
      "NeoAI",
      "NeoAIOpen",
      "NeoAIClose",
      "NeoAIToggle",
      "NeoAIContext",
      "NeoAIContextOpen",
      "NeoAIContextClose",
      "NeoAIInject",
      "NeoAIInjectCode",
      "NeoAIInjectContext",
      "NeoAIInjectContextCode",
    },
    keys = {
      { "<leader>as", desc = "summarize text" },
      { "<leader>ag", desc = "generate git message" },
    },
    config = function()
      require("neoai").setup({
        -- Options go here
      })
    end,
  },
  -- { 'Bekaboo/dropbar.nvim', event = "VeryLazy" },
  {
    "dnlhc/glance.nvim",
    config = function()
      require('glance').setup({
        -- your configuration
      })
    end,
    event = "VeryLazy"
  },
  {
    'gbrlsnchs/winpick.nvim',
    config = function()
      require('winpick').setup({
        format_label = function(label, _, _)
          return string.format('%s', label)
        end,
        border = "rounded",
        filter = function(winid, bufnr)
          local excluded_filetypes = { "nofile" }
          local buftype = vim.api.nvim_buf_get_option(bufnr, "buftype")

          if vim.tbl_contains(excluded_filetypes, buftype) then
            return false
          end

          return true
        end,
      })
    end,
  },
  {
    'axkirillov/hbac.nvim',
    dependencies = {
      -- these are optional, add them, if you want the telescope module
      'nvim-telescope/telescope.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons'
    },
    config = function()
      require("hbac").setup({
        threshold = 15
      })
    end,
    event = "VeryLazy"
  },
  {
    'AckslD/messages.nvim',
    config = function()
      require("messages").setup()
    end,
    event = "VeryLazy"
  },
  {
    "svermeulen/text-to-colorscheme.nvim",
    config = function()
      require('text-to-colorscheme').setup {
        ai = {
          openai_api_key = os.getenv("OPENAI_API_KEY"),
          gpt_model = "gpt-3.5-turbo-0613",
        },
      }
    end,
    event = "VeryLazy"
  },
  {
    'tomiis4/Hypersonic.nvim',
    cmd = "Hypersonic",
    config = function()
      require('hypersonic').setup({
        -- config
      })
    end
  },
  {
    "danielfalk/smart-open.nvim",
    branch = "0.2.x",
    config = function()
      require "telescope".load_extension("smart_open")
    end,
    dependencies = {
      "kkharji/sqlite.lua",
    }
  },
  {
    "nacro90/numb.nvim",
    config = function()
      require("numb").setup {
      }
    end,
    event = "BufRead",
  },
  -- {
  --   'echasnovski/mini.map',
  --   version = '*',
  --   config = function()
  --     require('mini.map').setup({
  --       -- config
  --     })
  --   end,
  --   event = "BufRead",
  -- },
  -- {
  --   "wfxr/minimap.vim",
  --   event = "BufRead",
  -- }
}
