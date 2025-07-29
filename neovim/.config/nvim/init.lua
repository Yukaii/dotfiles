vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
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
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/echasnovski/mini.nvim" },
	{ src = "https://github.com/folke/which-key.nvim" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/FabijanZulj/blame.nvim" },
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

require "mini.pick".setup()
require "nvim-treesitter.configs".setup({
	ensure_installed = { "svelte", "typescript", "javascript" },
	highlight = { enable = true }
})
require "oil".setup()
require 'mini.comment'.setup()
require 'gitsigns'.setup()
require 'blame'.setup()


require("which-key").setup()

require("which-key").add({
	{ "<leader>o", ":update<CR> :source<CR>", desc = "Update and source" },
	{ "<leader>w", ":write<CR>", desc = "Write file" },
	{ "<leader>q", ":quit<CR>", desc = "Quit" },
	{ "<leader>c", ":bd<CR>", desc = "Close buffer" },
	{ "<leader>S", ":let _s=@/<Bar>:%s/\\s\\+$//e<Bar>:let @/=_s<Bar><CR>", desc = "Trim trailing whitespace" },
	{ "<leader>,", ":e ~/.config/nvim/init.lua<CR>", desc = "Open config" },

	{ "<leader>y", '"+y', desc = "Yank to clipboard", mode = { "n", "v", "x" } },
	{ "<leader>d", '"+d', desc = "Delete to clipboard", mode = { "n", "v", "x" } },

	{ "<leader>f", group = "Find" },
	{ "<leader>ff", ":Pick files<CR>", desc = "Find files" },
	{ "<leader>fw", ":Pick grep_live<CR>", desc = "Find word" },
	{ "<leader>fb", ":Pick buffers<CR>", desc = "Find buffers" },
	{ "<leader>fh", ":Pick help<CR>", desc = "Find help" },
	{ "<leader>fe", ":Oil<CR>", desc = "File explorer" },

	{ "<leader>l", group = "LSP" },
	{ "<leader>lf", vim.lsp.buf.format, desc = "Format" },

	{ "<leader>g", group = "Git" },
	{ "<leader>gb", group = "Git Blame" },
	{ "<leader>gbl", function() require('gitsigns').blame_line() end, desc = "Blame line" },
	{ "<leader>gba", function() vim.cmd("BlameToggle") end, desc = "Toggle blame view" },
	{ "<leader>gp", function() require('gitsigns').preview_hunk() end, desc = "Preview hunk" },
	{ "<leader>gs", function() require('gitsigns').stage_hunk() end, desc = "Stage hunk" },
	{ "<leader>gu", function() require('gitsigns').undo_stage_hunk() end, desc = "Undo stage hunk" },
	{ "<leader>gr", function() require('gitsigns').reset_hunk() end, desc = "Reset hunk" },
	{ "]c", function() require('gitsigns').next_hunk() end, desc = "Next hunk" },
	{ "[c", function() require('gitsigns').prev_hunk() end, desc = "Previous hunk" },
})

vim.lsp.enable({ "lua_ls", "biome", "emmetls" })

require "kanagawa".setup({ transparent = true })
vim.cmd("colorscheme kanagawa")
