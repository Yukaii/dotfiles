return {
  -- Add the community repository of plugin specifications
  "AstroNvim/astrocommunity",
  -- example of imporing a plugin, comment out to use it or add your own
  -- available plugins can be found at https://github.com/AstroNvim/astrocommunity

  -- { import = "astrocommunity.colorscheme.catppuccin" },
  -- { import = "astrocommunity.completion.copilot-lua-cmp" },
  { import = "astrocommunity.colorscheme.kanagawa",                  enabled = true },
  { import = "astrocommunity.editing-support.zen-mode-nvim",         enabled = true },
  { import = "astrocommunity.motion.nvim-surround",                  enabled = true },
  { import = "astrocommunity.project.nvim-spectre",                  enabled = true },
  { import = "astrocommunity.markdown-and-latex.glow-nvim",          enabled = true },
  { import = "astrocommunity.editing-support.todo-comments-nvim",    enabled = true },
  { import = "astrocommunity.editing-support.nvim-ts-rainbow2",      enabled = true },
  { import = "astrocommunity.bars-and-lines.heirline-vscode-winbar", enabled = true },
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
  -- { import = "astrocommunity.completion.copilot-lua-cmp",            enabled = true },
  -- {
  --   "zbirenbaum/copilot.lua",
  --   config = function()
  --     require("copilot").setup({
  --       filetypes = {
  --         markdown = true,
  --         yaml = true,
  --       },
  --       copilot_node_command: ~/.volta/tools/image/node/18.14.2/bin/node
  --     })
  --   end
  -- }
  -- { import = "astrocommunity.motion.leap-nvim",                      enabled = true },
}
