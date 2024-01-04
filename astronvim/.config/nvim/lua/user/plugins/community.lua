return {
  -- Add the community repository of plugin specifications
  "AstroNvim/astrocommunity",
  -- example of imporing a plugin, comment out to use it or add your own
  -- available plugins can be found at https://github.com/AstroNvim/astrocommunity

  { import = "astrocommunity.colorscheme.rose-pine" },
  { import = "astrocommunity.colorscheme.github-nvim-theme" },
  { import = "astrocommunity.colorscheme.catppuccin" },
  { import = "astrocommunity.colorscheme.kanagawa-nvim" },
  { import = "astrocommunity.colorscheme.nordic-nvim" },
  {
    "rebelot/kanagawa.nvim",
    config = function()
      require('kanagawa').setup({
        colors = {
          theme = {
            all = {
              ui = {
                bg_gutter = "none"
              }
            }
          }
        },
        overrides = function(colors)
          local theme = colors.theme
          return {
            NormalFloat = { bg = "none" },
            FloatBorder = { bg = "none" },
            FloatTitle = { bg = "none" },

            -- Save an hlgroup with dark background and dimmed foreground
            -- so that you can use it where your still want darker windows.
            -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
            NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

            -- Popular plugins that open floats will link to NormalFloat by default;
            -- set their background accordingly if you wish to keep them dark and borderless
            LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
          }
        end,
      })
    end
  },
  { import = "astrocommunity.colorscheme.vscode-nvim" },
  { import = "astrocommunity.colorscheme.helix-nvim" },
  { import = "astrocommunity.colorscheme.tokyonight-nvim" },
  { import = "astrocommunity.editing-support.zen-mode-nvim" },
  -- { import = "astrocommunity.editing-support.true-zen-nvim" },
  { import = "astrocommunity.editing-support.todo-comments-nvim" },
  { import = "astrocommunity.editing-support.neogen" },
  -- { import = "astrocommunity.workflow.hardtime-nvim" },
  { import = "astrocommunity.motion.nvim-surround" },
  { import = "astrocommunity.project.nvim-spectre" },
  { import = "astrocommunity.markdown-and-latex.glow-nvim" },
  {
    "ellisonleao/glow.nvim",
    config = function()
      require('glow').setup({
        width = 120,
      })
    end
  },
  -- { import = "astrocommunity.bars-and-lines.smartcolumn-nvim" },
  { import = "astrocommunity.bars-and-lines.bufferline-nvim" },
  -- { import = "astrocommunity.bars-and-lines.heirline-vscode-winbar" },
  { import = "astrocommunity.bars-and-lines.dropbar-nvim" },
  {
    "akinsho/bufferline.nvim",
    event = { "BufReadPost" },
    config = function()
      require("bufferline").setup({
        options = {
          diagnostics = "nvim_lsp", -- | "nvim_lsp" | "coc",
          separator_style = "thin",
          -- diagnostics_indicator = function(count, _, _, _)
          --   if count > 9 then
          --     return "9+"
          --   end
          --   return tostring(count)
          -- end,
          offsets = {
            {
              filetype = "neo-tree",
              text = "EXPLORER",
              text_align = "center",
              highlight = "Directory",
            },
          },
          color_icons = false,
          -- custom_areas = {
          --   right = require("visual_studio_code").get_bufferline_right(),
          -- },
        },
      })
    end
  },
  { import = "astrocommunity.bars-and-lines.lualine-nvim" },
  {
    "m4xshen/smartcolumn.nvim",
    opts = {
      colorcolumn = 120,
      disabled_filetypes = { "help" },
    },
  },
  { import = "astrocommunity.git.neogit" },
  { import = "astrocommunity.git.blame-nvim" },
  { import = "astrocommunity.media.pets-nvim" },
  -- { import = "astrocommunity.scrolling.satellite-nvim" },
  -- { import = "astrocommunity.split-and-window.minimap-vim" },
  { import = "astrocommunity.git.octo-nvim" },
  { import = "astrocommunity.color.modes-nvim" },
  -- { import = "astrocommunity.color.transparent-nvim" },
  { import = "astrocommunity.completion.copilot-lua-cmp" },
  { import = "astrocommunity.completion.cmp-cmdline" },
  {
    "zbirenbaum/copilot.lua",
    config = function()
      require("copilot").setup({
        suggestion = { auto_trigger = true, debounce = 150 },
        copilot_node_command = vim.fn.expand("$HOME") .. "/.volta/tools/image/node/18.14.2/bin/node",
        filetypes = {
          yaml = true,
          markdown = true,
        }
      })
    end,
  },
  { import = "astrocommunity.motion.leap-nvim" },
  { import = "astrocommunity.motion.flit-nvim" },
  { import = "astrocommunity.motion.mini-move" },
  { import = "astrocommunity.note-taking.obsidian-nvim" },
  -- { import = "astrocommunity.pack.typescript-all-in-one" },
  { import = "astrocommunity.pack.tailwindcss" },
  { import = "astrocommunity.pack.yaml" },
  { import = "astrocommunity.pack.markdown" },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.go" },
  { import = "astrocommunity.pack.prisma" },
  { import = "astrocommunity.pack.java" },
  { import = "astrocommunity.register.nvim-neoclip-lua" },
}
