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
    "catppuccin/nvim",
    config = function()
      require('catppuccin').setup({
        flavour = "mocha"
      })
    end
  },
  {
    "projekt0n/github-nvim-theme",
    lazy = false,
    config = function()
      require('github-theme').setup()
    end
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    config = function()
      require('kanagawa').setup({})
    end
  },
  { 'ruifm/gitlinker.nvim',           lazy = false },
  { 'github/copilot.vim',             lazy = false },
  { 'ntpeters/vim-better-whitespace', lazy = false }
}
