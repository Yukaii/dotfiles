return {
  -- Add the community repository of plugin specifications
  "AstroNvim/astrocommunity",
  -- example of imporing a plugin, comment out to use it or add your own
  -- available plugins can be found at https://github.com/AstroNvim/astrocommunity

  { import = "astrocommunity.colorscheme.rose-pine" },
  { import = "astrocommunity.colorscheme.github-nvim-theme" },
  { import = "astrocommunity.colorscheme.catppuccin" },
  { import = "astrocommunity.colorscheme.kanagawa-nvim" },
  { import = "astrocommunity.editing-support.zen-mode-nvim" },
  { import = "astrocommunity.editing-support.todo-comments-nvim" },
  { import = "astrocommunity.editing-support.neogen" },
  { import = "astrocommunity.motion.nvim-surround" },
  { import = "astrocommunity.project.nvim-spectre" },
  { import = "astrocommunity.markdown-and-latex.glow-nvim" },
  { import = "astrocommunity.bars-and-lines.smartcolumn-nvim" },
  { import = "astrocommunity.bars-and-lines.bufferline-nvim" },
  {
    "akinsho/bufferline.nvim",
    event = { "BufReadPost" },
    opts = {
      options = {
        diagnostics = "nvim_lsp",      -- | "nvim_lsp" | "coc",
        separator_style = "slant",
        close_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
        diagnostics_indicator = function(count, _, _, _)
          if count > 9 then
            return "9+"
          end
          return tostring(count)
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "EXPLORER",
            text_align = "center",
            highlight = "Directory",
          },
        },
        hover = {
          enabled = true,
          delay = 200,
          reveal = { "close" },
        },
        color_icons = false,
      },
    },
  },
  {
    "m4xshen/smartcolumn.nvim",
    opts = {
      colorcolumn = 120,
      disabled_filetypes = { "help" },
    },
  },
  { import = "astrocommunity.git.neogit" },
  { import = "astrocommunity.media.pets-nvim" },
  { import = "astrocommunity.scrolling.satellite-nvim" },
  { import = "astrocommunity.git.octo" },
  { import = "astrocommunity.color.modes-nvim" },
  { import = "astrocommunity.completion.copilot-lua-cmp" },
  -- {
  --   "zbirenbaum/copilot.lua",
  --   config = function()
  --     require("copilot").setup({
  --       filetypes = {
  --         markdown = true,
  --         yaml = true,
  --       },
  --       copilot_node_command = "~/.volta/tools/image/node/18.14.2/bin/node"
  --     })
  --   end
  -- }
  { import = "astrocommunity.motion.leap-nvim" },
  { import = "astrocommunity.motion.mini-move" },
  { import = "astrocommunity.note-taking.obsidian-nvim" }
}
