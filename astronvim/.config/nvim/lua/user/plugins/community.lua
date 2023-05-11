return {
  -- Add the community repository of plugin specifications
  "AstroNvim/astrocommunity",
  -- example of imporing a plugin, comment out to use it or add your own
  -- available plugins can be found at https://github.com/AstroNvim/astrocommunity

  { import = "astrocommunity.colorscheme.catppuccin" },
  { import = "astrocommunity.colorscheme.kanagawa" },
  { import = "astrocommunity.editing-support.zen-mode-nvim" },
  { import = "astrocommunity.motion.nvim-surround" },
  { import = "astrocommunity.project.nvim-spectre" },
  { import = "astrocommunity.markdown-and-latex.glow-nvim" },
  { import = "astrocommunity.editing-support.todo-comments-nvim" },
  -- { import = "astrocommunity.editing-support.nvim-ts-rainbow2" },
  { import = "astrocommunity.bars-and-lines.heirline-vscode-winbar" },
  -- { import = "astrocommunity.scrolling.nvim-scrollbar" },
  { import = "astrocommunity.bars-and-lines.smartcolumn-nvim" },
  {
    "m4xshen/smartcolumn.nvim",
    opts = {
      colorcolumn = 120,
      disabled_filetypes = { "help" },
    },
  },
  { import = "astrocommunity.git.neogit" },
  { import = "astrocommunity.media.pets-nvim" },
  {
    "giusgad/pets.nvim",
    opts = {
      row = 8,
      default_pet = "slime",
      default_style = "green",
      random = false,
      popup = {
        winblend = 100,
        avoid_statusline = true
      }
    }
  },
  { import = "astrocommunity.scrolling.satellite-nvim" },
  -- { import = "astrocommunity.completion.copilot-lua-cmp" },
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
  -- { import = "astrocommunity.motion.leap-nvim",                      enabled = true },
}
