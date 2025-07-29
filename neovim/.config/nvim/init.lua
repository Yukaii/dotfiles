vim.o.number = true
vim.o.relativenumber = true
-- vim.o.signcolumn = "yes:3"
vim.o.termguicolors = true
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.swapfile = false
vim.g.mapleader = " "
vim.o.winborder = "rounded"
vim.o.clipboard = "unnamedplus"
vim.o.autoread = true

vim.pack.add({
	{ src = "https://github.com/rebelot/kanagawa.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/echasnovski/mini.nvim" },
	{ src = "https://github.com/folke/which-key.nvim" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/FabijanZulj/blame.nvim" },
	{ src = "https://github.com/linrongbin16/gitlinker.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/ThePrimeagen/harpoon" },
})

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
	callback = function()
		if vim.fn.mode() ~= 'c' then
			vim.cmd('checktime')
		end
	end,
})
vim.cmd("set completeopt+=noselect")

local zen_mode = false
local function toggle_zen_mode()
	zen_mode = not zen_mode
	if zen_mode then
		vim.o.number = false
		vim.o.relativenumber = false
		vim.o.signcolumn = "no"
		vim.cmd("set columns=120")
	else
		vim.o.number = true
		vim.o.relativenumber = true
		vim.o.signcolumn = "yes:3"
		vim.cmd("set columns&")
	end
end

require "mini.pick".setup()
require "nvim-treesitter.configs".setup({
	ensure_installed = { "svelte", "typescript", "javascript" },
	highlight = { enable = true }
})
require "oil".setup()
require 'gitsigns'.setup()
require 'blame'.setup()
pcall(function() require('gitlinker').setup() end)
require 'mini.comment'.setup()
require('mini.starter').setup()
require('mini.cursorword').setup()
require('mini.statusline').setup()
require('mini.tabline').setup()
require('mini.icons').setup()
require('mini.notify').setup()
require('mini.git').setup()
require('mini.diff').setup()

require("which-key").setup()
require("which-key").add({
	{ "<leader>C",   ":update<CR> :source<CR>",                                                               desc = "Update and source" },
	{ "<leader>w",   ":write<CR>",                                                                            desc = "Write file" },
	{ "<leader>q",   ":bd<CR>",                                                                               desc = "Quit" },
	{ "<leader>c",   ":bd<CR>",                                                                               desc = "Close buffer" },
	{ "<leader>S",   ":let _s=@/<Bar>:%s/\\s\\+$//e<Bar>:let @/=_s<Bar><CR>",                                 desc = "Trim trailing whitespace" },
	{ "<leader>,",   ":e ~/.config/nvim/init.lua<CR>",                                                        desc = "Open config" },

	{ "<leader>/",   function() require('mini.comment').toggle_lines(vim.fn.line('.'), vim.fn.line('.')) end, desc = "Toggle comment",          mode = "n" },
	{ "<leader>/",   function() require('mini.comment').toggle_lines(vim.fn.line('v'), vim.fn.line('.')) end, desc = "Toggle comment",          mode = { "v", "x" } },

	{ "<leader>f",   group = "Find" },
	{ "<leader>ff",  ":Pick files<CR>",                                                                       desc = "Find files" },
	{ "<leader>fw",  ":Pick grep_live<CR>",                                                                   desc = "Find word" },
	{ "<leader>fb",  ":Pick buffers<CR>",                                                                     desc = "Find buffers" },
	{ "<leader>fh",  ":Pick help<CR>",                                                                        desc = "Find help" },
	{ "<leader>fe",  ":Oil<CR>",                                                                              desc = "File explorer" },

	{ "<leader>l",   group = "LSP" },
	{ "<leader>lf",  vim.lsp.buf.format,                                                                      desc = "Format" },

	{ "<leader>t",   group = "Terminal" },
	{ "<leader>tl",  ":silent !tsm popup lazygit<CR>",                                                        desc = "Lazygit" },
	{ "<leader>tf",  ":silent !tsm popup<CR>",                                                                desc = "Terminal popup" },
	{ "<leader>tj",  ":silent !tsm popup lazyjj<CR>",                                                         desc = "Lazyjj" },
	{ "<leader>tr",  ":silent !tsm popup serpl<CR>",                                                          desc = "Serpl" },
	{ "<leader>tb",  ":silent !winmux sp fish<CR>",                                                           desc = "Bottom terminal" },

	{ "<leader>u",   group = "UI" },
	{ "<leader>uw",  function() vim.o.wrap = not vim.o.wrap end,                                              desc = "Toggle wrap" },
	{ "<leader>uz",  toggle_zen_mode,                                                                         desc = "Toggle zen mode" },

	{ "<leader>g",   group = "Git" },
	{ "<leader>gb",  group = "Git Blame" },
	{ "<leader>gbl", function() require('gitsigns').blame_line() end,                                         desc = "Blame line" },
	{ "<leader>gba", function() vim.cmd("BlameToggle") end,                                                   desc = "Toggle blame view" },
	{ "<leader>gp",  function() require('gitsigns').preview_hunk() end,                                       desc = "Preview hunk" },
	{ "<leader>gs",  function() require('gitsigns').stage_hunk() end,                                         desc = "Stage hunk" },
	{ "<leader>gu",  function() require('gitsigns').undo_stage_hunk() end,                                    desc = "Undo stage hunk" },
	{ "<leader>gr",  function() require('gitsigns').reset_hunk() end,                                         desc = "Reset hunk" },
	{ "<leader>gy",  function() vim.cmd("GitLink") end,                                                       desc = "Copy Git Permalink",      mode = { "n", "v", "x" } },

	{ "<leader>o",   group = "Harpoon" },
	{ "<leader>oa",  function() require("harpoon.mark").add_file() end,                                       desc = "Add file" },
	{ "<leader>ol",  function() require("harpoon.ui").toggle_quick_menu() end,                                desc = "List files" },
	{ "<leader>on",  function() require("harpoon.ui").nav_next() end,                                         desc = "Next file" },
	{ "<leader>op",  function() require("harpoon.ui").nav_prev() end,                                         desc = "Previous file" },
	{ "<leader>o1",  function() require("harpoon.ui").nav_file(1) end,                                        desc = "File 1" },
	{ "<leader>o2",  function() require("harpoon.ui").nav_file(2) end,                                        desc = "File 2" },
	{ "<leader>o3",  function() require("harpoon.ui").nav_file(3) end,                                        desc = "File 3" },
	{ "<leader>o4",  function() require("harpoon.ui").nav_file(4) end,                                        desc = "File 4" },
	{ "<leader>o5",  function() require("harpoon.ui").nav_file(5) end,                                        desc = "File 5" },
	{ "<leader>o6",  function() require("harpoon.ui").nav_file(6) end,                                        desc = "File 6" },
	{ "<leader>o7",  function() require("harpoon.ui").nav_file(7) end,                                        desc = "File 7" },
	{ "<leader>o8",  function() require("harpoon.ui").nav_file(8) end,                                        desc = "File 8" },
	{ "<leader>o9",  function() require("harpoon.ui").nav_file(9) end,                                        desc = "File 9" },
	{ "<leader>o0",  function() require("harpoon.ui").nav_file(10) end,                                       desc = "File 10" },
	{ "]c",          function() require('gitsigns').next_hunk() end,                                          desc = "Next hunk" },
	{ "[c",          function() require('gitsigns').prev_hunk() end,                                          desc = "Previous hunk" },
	{ "]t",          ":tabnext<CR>",                                                                          desc = "Next tab" },
	{ "[t",          ":tabprevious<CR>",                                                                      desc = "Previous tab" },
})

vim.lsp.enable({ "lua_ls", "biome", "emmetls", "ts_ls", "eslint" })

require "kanagawa".setup({ transparent = true })
vim.cmd("colorscheme kanagawa")
