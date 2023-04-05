-- set vim options here (vim.<first_key>.<second_key> = value)
return {
  opt = {
    -- set to true or false etc.
    relativenumber = true, -- sets vim.opt.relativenumber
    number = true,         -- sets vim.opt.number
    spell = false,         -- sets vim.opt.spell
    signcolumn = "auto",   -- sets vim.opt.signcolumn to auto
    wrap = true,           -- sets vim.opt.wrap
    guifont = "JetbrainsMono Nerd Font:h17:#h-normal",
    cursorcolumn = true,
    conceallevel = 2,
  },
  g = {
    mapleader = " ",                 -- sets vim.g.mapleader
    autoformat_enabled = true,       -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
    cmp_enabled = true,              -- enable completion at start
    autopairs_enabled = true,        -- enable autopairs at start
    diagnostics_mode = 3,            -- set the visibility of diagnostics in the UI (0=off, 1=only show in status line, 2=virtual text off, 3=all on)
    icons_enabled = true,            -- disable icons in the UI (disable if no nerd font is available, requires :PackerSync after changing)
    ui_notifications_enabled = true, -- disable notifications when toggling UI elements
    copilot_no_tab_map = true,
    copilot_assume_mapped = true,
    copilot_node_command = "~/.volta/tools/image/node/18.14.2/bin/node",
    copilot_filetypes = {
      markdown = true,
      yaml = true,
    },
    better_whitespace_enabled = false,
    vim_markdown_new_list_item_indent = 2,
    vim_markdown_frontmatter = 1,
    vim_markdown_folding_level = 6,
    vim_markdown_conceal_code_blocks = 0,
    markdown_fenced_languages = {
      'javascript=js',
      'ruby=rb',
      'rust=rs',
      'typescript=ts',
      'python=py',
    },
    neovide_transparency = 0.9,
    neovide_floating_blur_amount_x = 2.0,
    neovide_floating_blur_amount_y = 2.0,
  },
}
-- If you need more control, you can use the function()...end notation
-- return function(local_vim)
--   local_vim.opt.relativenumber = true
--   local_vim.g.mapleader = " "
--   local_vim.opt.whichwrap = vim.opt.whichwrap - { 'b', 's' } -- removing option from list
--   local_vim.opt.shortmess = vim.opt.shortmess + { I = true } -- add to option list
--
--   return local_vim
-- end
