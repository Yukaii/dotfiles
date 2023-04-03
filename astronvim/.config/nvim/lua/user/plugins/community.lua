return {
  -- Add the community repository of plugin specifications
  "AstroNvim/astrocommunity",
  -- example of imporing a plugin, comment out to use it or add your own
  -- available plugins can be found at https://github.com/AstroNvim/astrocommunity

  -- { import = "astrocommunity.colorscheme.catppuccin" },
  -- { import = "astrocommunity.completion.copilot-lua-cmp" },
  { import = "astrocommunity.colorscheme.kanagawa",               enabled = true },
  { import = "astrocommunity.editing-support.zen-mode-nvim",      enabled = true },
  { import = "astrocommunity.motion.nvim-surround",               enabled = true },
  { import = "astrocommunity.project.nvim-spectre",               enabled = true },
  { import = "astrocommunity.markdown-and-latex.glow-nvim",       enabled = true },
  { import = "astrocommunity.editing-support.todo-comments-nvim", enabled = true },
  { import = "astrocommunity.editing-support.nvim-ts-rainbow2",   enabled = true },
  { import = "astrocommunity.bars-and-lines.bufferline-nvim",     enabled = true },
}
