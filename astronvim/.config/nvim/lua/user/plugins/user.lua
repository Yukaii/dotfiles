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
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_node_command = "~/.volta/tools/image/node/18.14.2/bin/node"
    end
  }
}
