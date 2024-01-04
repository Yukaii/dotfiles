return {
  -- Configure AstroNvim updates
  updater = {
    remote = "origin",     -- remote to use
    channel = "stable",    -- "stable" or "nightly"
    version = "latest",    -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
    branch = "nightly",    -- branch name (NIGHTLY ONLY)
    commit = nil,          -- commit hash (NIGHTLY ONLY)
    pin_plugins = nil,     -- nil, true, false (nil will pin plugins on stable only)
    skip_prompts = false,  -- skip prompts about breaking changes
    show_changelog = true, -- show the changelog after performing an update
    auto_quit = false,     -- automatically quit the current session after a successful update
    remotes = {            -- easily add new remotes to track
      --   ["remote_name"] = "https://remote_url.come/repo.git", -- full remote url
      --   ["remote2"] = "github_user/repo", -- GitHub user/repo shortcut,
      --   ["remote3"] = "github_user", -- GitHub user assume AstroNvim fork
    },
  },
  -- Set colorscheme to use
  -- colorscheme = "catppuccin-macchiato",
  colorscheme = "kanagawa",
  -- colorscheme = "nordic",
  -- colorscheme = "flexoki",
  -- colorscheme = "arctic",
  -- colorscheme = "visual_studio_code_dark",
  -- colorscheme = "tokyonight",
  -- colorscheme = "astromars",
  -- colorscheme = "github_dark_high_contrast",
  -- colorscheme = "kanagawabones",
  -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
  diagnostics = {
    virtual_text = false,
    underline = true,
  },
  lsp = {
    -- customize lsp formatting options
    formatting = {
      -- control auto formatting on save
      format_on_save = {
        enabled = false,    -- enable or disable format on save globally
        allow_filetypes = { -- enable format on save for specified filetypes only
          -- "go",
          "lua",
          "go"
        },
        ignore_filetypes = { -- disable format on save for specified filetypes
          -- "python",
        },
      },
      disabled = { -- disable formatting capabilities for the listed language servers
        -- "sumneko_lua",
      },
      timeout_ms = 1000, -- default format timeout
      -- filter = function(client) -- fully override the default formatting function
      --   return true
      -- end
    },
    -- enable servers that you already have installed without mason
    servers = {
      -- "pyright"
    },
    config = {
      eslint = {
        on_attach = function(client, bufnr)
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "silent! EslintFixAll",
          })
        end,
      }
    },
  },

  -- Configure require("lazy").setup() options
  lazy = {
    defaults = { lazy = true },
    performance = {
      rtp = {
        -- customize default disabled vim plugins
        disabled_plugins = { "tohtml", "gzip", "matchit", "zipPlugin", "netrwPlugin", "tarPlugin" },
      },
    },
  },
  -- This function is run last and is a good place to configuring
  -- augroups/autocommands and custom filetypes also this just pure lua so
  -- anything that doesn't fit in the normal config locations above can go here
  polish = function()
    -- Set up custom filetypes
    -- vim.filetype.add {
    --   extension = {
    --     foo = "fooscript",
    --   },
    --   filename = {
    --     ["Foofile"] = "fooscript",
    --   },
    --   pattern = {
    --     ["~/%.config/foo/.*"] = "fooscript",
    --   },
    -- }

    vim.cmd [[
      function! SaveJump(motion)
        if exists('#SaveJump#CursorMoved')
          autocmd! SaveJump
        else
          normal! m'
        endif
        let m = a:motion
        if v:count
          let m = v:count.m
        endif
        execute 'normal!' m
      endfunction

      function! SetJump()
        augroup SaveJump
          autocmd!
          autocmd CursorMoved * autocmd! SaveJump
        augroup END
      endfunction

      nnoremap <silent> <C-u> :<C-u>call SaveJump("\<lt>C-u>")<CR>:call SetJump()<CR>
      nnoremap <silent> <C-d> :<C-u>call SaveJump("\<lt>C-d>")<CR>:call SetJump()<CR>
      nnoremap <silent> <C-f> :<C-u>call SaveJump("\<lt>C-f>")<CR>:call SetJump()<CR>
      nnoremap <silent> <C-b> :<C-u>call SaveJump("\<lt>C-b>")<CR>:call SetJump()<CR>
    ]]

    require('toggleterm').setup {
      shell = 'fish'
    }

    vim.o.langmenu = 'en_US'

    if vim.g.neovide then
      -- local alpha = function()
      --   return string.format("%x", math.floor((255 * vim.g.transparency) or 0.8))
      -- end
      --
      -- local bg_color = vim.api.nvim_get_hl_by_name("Normal", true).background
      -- local hex_color = string.format("#%x", bg_color)
      --
      -- -- g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
      -- vim.g.neovide_transparency = 0.0
      -- vim.g.transparency = 0.95
      -- vim.g.neovide_background_color = hex_color .. alpha()

      vim.g.neovide_cursor_vfx_mode = "railgun"
    end

    require("oil").setup()
  end,
}
