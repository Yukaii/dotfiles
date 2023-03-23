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
  { 'ruifm/gitlinker.nvim', lazy = false },
  {
    'github/copilot.vim',
    lazy = false,
    config = function()
      -- require('copilot').setup({
      --   accept = '<M-l>'
      -- })
    end
  },
}
