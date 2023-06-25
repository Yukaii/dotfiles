-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)


return {
  -- first key is the mode
  n = {
    -- second key is the lefthand side of the map
    -- mappings seen under group name "Buffer"
    ["<leader>bn"]       = { "<cmd>tabnew<cr>", desc = "New tab" },
    ["<leader>bD"]       = {
      function()
        require("astronvim.utils.status").heirline.buffer_picker(function(bufnr)
          require("astronvim.utils.buffer").close(
            bufnr)
        end)
      end,
      desc = "Pick to close",
    },
    -- tables with the `name` key will be registered with which-key if it's installed
    -- this is useful for naming menus
    ["<leader>b"]        = { name = "Buffers" },
    ["<leader>gy"]       = { desc = "Copy GitHub URL" },
    ["<leader>gB"]       = { "<cmd>Git blame<cr>", desc = "Show Git Blame" },
    ["<leader>s"]        = { name = "Search and Format" },
    ["<leader>s<space>"] = {
      "<cmd>StripWhitespace<cr>",
      desc = "Strip whitespace",
    },
    ["<leader>ss"]       = { function() require("spectre").open() end, desc = "Search" },
    ["<leader>sw"]       = { function() require("spectre").open_visual { select_word = true } end, desc =
    "Search current word" },
    ["<leader>sr"]       = { "<cmd>e!<cr>", desc = "Reload file" },
    ["<leader>sg"]       = { "<cmd>Glow<cr>", desc = "Preview markdown with glow" },
    ["<leader>fT"]       = { function() require('telescope-tabs').list_tabs() end, desc = "Find tabs" },
    ["<leader>fg"]       = { function() require 'telescope.builtin'.git_files() end, desc = "Find git files" },
    ["<leader>fd"]       = { function() require('dropbar.api').pick() end, desc = "Pick dropbar item" },
    ["<leader>tg"]       = {
      function()
        require("astronvim.utils").toggle_term_cmd("tig")
      end,
      desc = "ToggleTerm tig",
    },
    ["<leader>tt"]       = {
      function()
        require("astronvim.utils").toggle_term_cmd("btop")
      end,
      desc = "ToggleTerm btop"
    },
    ["<leader>tb"]       = {
      function()
        require("astronvim.utils").toggle_term_cmd("git-bug termui")
      end,
      desc = "ToggleTerm git-bug"
    },
    ["<leader>ts"]       = {
      function()
        require("astronvim.utils").toggle_term_cmd("spt")
      end,
      desc = "ToggleTerm spotify-tui"
    },
    ["<leader>td"]       = {
      function()
        require("astronvim.utils").toggle_term_cmd("lazydocker")
      end,
      desc = "ToggleTerm lazydocker"
    },
    ["<leader>tm"]       = {
      function()
        require("astronvim.utils").toggle_term_cmd("mprocs --npm")
      end,
      desc = "ToggleTerm mprocs for package.json"
    },
    ["<leader>tM"]       = {
      function()
        require("astronvim.utils").toggle_term_cmd("mprocs")
      end,
      desc = "ToggleTerm mprocs"
    },
    ["<leader>c"]        = {
      function()
        local bufs = vim.fn.getbufinfo { buflisted = true }
        require("astronvim.utils.buffer").close(0)
        if require("astronvim.utils").is_available "alpha-nvim" and not bufs[2] then require("alpha").start(true) end
      end,
      desc = "Close buffer",
    },
    ["<leader>y"]        = { name = "Yank commands" },
    ["<leader>yp"]       = { "<cmd>let @+ = expand('%')<cr>", desc = "Copy file relative path" },
    ["<leader>z"]        = { name = "Folding" },
    ["<leader>Z"]        = { "<cmd>ZenMode<cr>" },
    ["<leader>fp"]       = {
      "<cmd>Telescope file_browser path=%:p:h select_buffer=true hidden=true respect_gitignore=false display_stat=false<cr>", desc =
    "Open directory relative to current buffer" },
    ["<leader>fP"]       = { "<cmd>Telescope file_browser hidden=true respect_gitignore=false display_stat=false<cr>", desc =
    "Open Telescope  file broser" },
    ["<leader>fj"]       = { "<cmd>lua require('telescope.builtin').jumplist()<cr>", desc = "Find jumplist" },
    ["<leader><leader>"] = {
      "<Cmd>lua require('telescope').extensions.smart_open.smart_open({ cwd_only = true })<CR>",
      desc = "Smart open"
    },

    -- Octo actions
    ["<leader>Of"]       = { "<cmd>Octo actions<cr>", desc = "List Octo actions" },
    ["<leader>-"]        = { name = "Oil" },
    ["<leader>--"]       = { require("oil").open_float, desc = "Open directory" },
    ["<leader>-h"]       = { require("oil").toggle_hidden, desc = "Toggle hidden files" },

    -- Bufferline mappings override
    ["<leader>bb"]       = { "<cmd>BufferLinePick<cr>", desc = "Pick buffer" },
    ["<leader>bD"]       = { "<cmd>BufferLinePickClose<CR>", desc = "Pick to close" },
    ["<leader>bp"]       = { "<cmd>BufferLineTogglePin<cr>", desc = "Toggle Pinning" },
    ["<leader>bC"]       = { function()
      local bufferline = require('bufferline')
      for _, e in ipairs(bufferline.get_elements().elements) do
        vim.schedule(function()
          vim.cmd("bd " .. e.id)
        end)
      end
    end, desc = "Close all buffers"
    },

    -- quick save
    -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command
    ["<C-l>"]            = false,
    ["<C-h>"]            = false,
    ["<C-j>"]            = false,
    ["<C-k>"]            = false,
    ["<C-p>"]            = {
      "<cmd>lua require('telescope').extensions.frecency.frecency({ show_unindexed = false })<CR>",
      desc = "Telescope Frecency",
    },
    ["j"]                = { "v:count ? (v:count > g:jk_jumps_minimum_lines ? \"m'\" . v:count : '') . 'j' : 'gj'", expr = true, desc =
    "Move cursor down" },
    ["k"]                = { "v:count ? (v:count > g:jk_jumps_minimum_lines ? \"m'\" . v:count : '') . 'k' : 'gk'", expr = true },
    ["gp"]               = { "<cmd>Lspsaga peek_definition<CR>" },
    ['gD']               = { '<CMD>Glance definitions<CR>' },
    ['gR']               = { '<CMD>Glance references<CR>' },
    ['gY']               = { '<CMD>Glance type_definitions<CR>' },
    ['gM']               = { '<CMD>Glance implementations<CR>' },
    ["K"]                = { "<cmd>Lspsaga hover_doc<CR>" },

    -- extend Ctrl-W mappings
    ["<C-w>p"]           = {
      function()
        local winpick = require('winpick')
        local winid = winpick.select()

        if winid then
          vim.api.nvim_set_current_win(winid)
        end
      end,
      desc = "Pick window",
    }
  },
  t = {
    -- setting a mapping to false will disable it
    -- ["<esc>"] = false,
  },
  i = {
    ["<M-l>"] = {
      "copilot#Accept(<Tab>)",
      silent = true,
      expr = true,
      script = true,
      replace_keycodes = false,
    },
  },
}
