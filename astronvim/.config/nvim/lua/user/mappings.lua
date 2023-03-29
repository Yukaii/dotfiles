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
    ["<leader>bn"] = { "<cmd>tabnew<cr>", desc = "New tab" },
    ["<leader>bD"] = {
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
    ["<leader>b"] = { name = "Buffers" },
    ["<leader>gy"] = { desc = "Copy GitHub URL" },
    ["<leader>s"] = { name = "Search and Format" },
    ["<leader>s<space>"] = {
      "<cmd>StripWhitespace<cr>",
      desc = "Strip whitespace",
    },
    ["<leader>ss"] = { function() require("spectre").open() end, desc = "Search" },
    ["<leader>sw"] = { function() require("spectre").open_visual { select_word = true } end, desc = "Search current word" },
    ["<leader>fT"] = { function() require('telescope-tabs').list_tabs() end, desc = "Find tabs" },
    ["<leader>tg"] = {
      function()
        require("astronvim.utils").toggle_term_cmd("tig")
      end,
      desc = "ToggleTerm tig",
    },
    ["<leader>tt"] = {
      function()
        require("astronvim.utils").toggle_term_cmd("btop")
      end,
      desc = "ToggleTerm btop"
    },
    ["<leader>tb"] = {
      function()
        require("astronvim.utils").toggle_term_cmd("git-bug termui")
      end,
      desc = "ToggleTerm git-bug"
    },
    ["<leader>ts"] = {
      function()
        require("astronvim.utils").toggle_term_cmd("spt")
      end,
      desc = "ToggleTerm spotify-tui"
    },
    ["<leader>c"] = {
      function()
        local bufs = vim.fn.getbufinfo { buflisted = true }
        require("astronvim.utils.buffer").close(0)
        if require("astronvim.utils").is_available "alpha-nvim" and not bufs[2] then require("alpha").start(true) end
      end,
      desc = "Close buffer",
    },
    ["<leader>z"] = { name = "Folding" },
    ["<leader>Z"] = { "<cmd>ZenMode<cr>" },
    -- quick save
    -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command
    ["<C-l>"] = false,
    ["<C-h>"] = false,
    ["<C-j>"] = false,
    ["<C-k>"] = false,
    ["<C-p>"] = {
      "<cmd>lua require('telescope').extensions.frecency.frecency({ show_unindexed = false })<CR>",
      desc = "Telescope Frecency",
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
