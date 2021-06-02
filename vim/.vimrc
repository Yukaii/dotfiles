" Vim plug auto installation
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" #############
" # UTILITIES #
" #############

" NerdTree
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'unkiwii/vim-nerdtree-sync'

" Asynchronous Lint Engine
" Plug 'w0rp/ale'

" Plug 'airblade/vim-gitgutter'
" Plug 'asvetliakov/vim-easymotion' " vim neovim fork
Plug 'easymotion/vim-easymotion', { 'as': 'easymotion' }
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive' " Git Commands
Plug 'tpope/vim-rhubarb' " GitHub related
Plug 'jreybert/vimagit' " Magit
Plug 'ntpeters/vim-better-whitespace'
Plug 'tpope/vim-sleuth' " Auto detect indentation
Plug 'wakatime/vim-wakatime'
" Plug 'tpope/vim-endwise'
Plug 'scrooloose/nerdcommenter' " Toggle comment
Plug 'tpope/vim-sensible' " General config
Plug 'moll/vim-bbye'
" Plug 'mattn/emmet-vim'
Plug 'terryma/vim-multiple-cursors'
Plug 's3rvac/AutoFenc'
Plug 'Yggdroot/indentLine'

Plug 'xolox/vim-misc' " Session management
Plug 'xolox/vim-session' " Session management

Plug 'farmergreg/vim-lastplace'

Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'

Plug 'google/vim-searchindex'
Plug 't9md/vim-choosewin'
Plug 'wincent/terminus'
Plug 'wincent/ferret'

" ####################
" # LANGUAGE SUPPORT #
" ####################

" Syntax
Plug 'sheerun/vim-polyglot'
Plug 'dag/vim-fish'
Plug 'editorconfig/editorconfig-vim'
Plug 'gisphm/vim-gitignore'
Plug 'nikvdp/ejs-syntax'
Plug 'PProvost/vim-ps1'
Plug 'tpope/vim-liquid'
Plug 'leafgarland/typescript-vim'
Plug 'posva/vim-vue'
Plug 'fatih/vim-go'
Plug 'vim-ruby/vim-ruby'
Plug 'joker1007/vim-ruby-heredoc-syntax'
Plug 'tpope/vim-dotenv'
Plug 'godlygeek/tabular' " vim-markdown dependency
Plug 'plasticboy/vim-markdown'
Plug 'tpope/vim-rails'
Plug 'LnL7/vim-nix'

" Tree sitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'

Plug 'neovim/nvim-lspconfig'

" ###################
" # THEMES & COLORS #
" ###################

" Colorschemes
Plug 'ayu-theme/ayu-vim'
Plug 'wojciechkepka/vim-github-dark'
" Plug 'junegunn/seoul256.vim'
" Plug 'w0ng/vim-hybrid'
" Plug 'phanviet/vim-monokai-pro'

" Customization
" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'
Plug 'itchyny/lightline.vim'
" Plug 'mengelbrecht/lightline-bufferline'
Plug 'akinsho/nvim-bufferline.lua'

" Plug 'edkolev/tmuxline.vim'

" Telescope & deps
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" (Optional) Showing function signature and inline doc.
Plug 'Shougo/echodoc.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'hrsh7th/nvim-compe'

call plug#end()

" ##################
" # GENERAL CONFIG #
" ##################

set number
set relativenumber
set cursorline
set mouse=a
set wrap
set linebreak
set noshowmode

" persist undo history
set undofile
set undodir=~/.vim/undodir

" set to system keyboard
set clipboard+=unnamedplus

filetype plugin on

if has("termguicolors")     " set true colors
  set termguicolors
endif


" #################
" # PLUGIN CONFIG #
" #################

" let g:ale_linters = {
" \   'javascript': ['standard', 'tsserver'],
" \   'javascriptreact': ['standard', 'tsserver'],
" \}

" Enable completion where available.
" let g:ale_completion_enabled = 1

let g:nerdtree_sync_cursorline = 1

" NerdTree config
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let NERDTreeShowHidden=1

" NerdCommentor config

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

let ayucolor="mirage"

colorscheme ghdark

" let g:airline#extensions#tabline#enabled = 1
" let g:airline_solarized_bg='dark'

let g:lightline = {
  \ 'colorscheme': 'ghdark',
  \ 'separator': { 'left': '', 'right': '' },
  \ 'subseparator': { 'left': '', 'right': '' },
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'gitbranch', 'readonly', 'icon', 'relativepath', 'modified' ] ]
  \ },
  \ 'component_function': {
  \   'gitbranch': 'fugitive#head',
  \   'icon': 'WebDevIconsGetFileTypeSymbol',
  \ },
  \ 'enable': {
  \   'tabline': 0
  \ },
  \ 'component_expand': {'buffers': 'lightline#bufferline#buffers'},
  \ 'component_type': {'buffers': 'tabsel'},
  \ }

let g:lightline.component_raw = {'buffers': 1}
let g:lightline#bufferline#show_number = 2
let g:lightline#bufferline#number_map = {
\ 0: '⁰', 1: '¹', 2: '²', 3: '³', 4: '⁴',
\ 5: '⁵', 6: '⁶', 7: '⁷', 8: '⁸', 9: '⁹'}
let g:lightline#bufferline#enable_devicons = 1
let g:lightline#bufferline#clickable = 1

set showtabline=2

nmap <Leader>1 <Plug>lightline#bufferline#go(1)
nmap <Leader>2 <Plug>lightline#bufferline#go(2)
nmap <Leader>3 <Plug>lightline#bufferline#go(3)
nmap <Leader>4 <Plug>lightline#bufferline#go(4)
nmap <Leader>5 <Plug>lightline#bufferline#go(5)
nmap <Leader>6 <Plug>lightline#bufferline#go(6)
nmap <Leader>7 <Plug>lightline#bufferline#go(7)
nmap <Leader>8 <Plug>lightline#bufferline#go(8)
nmap <Leader>9 <Plug>lightline#bufferline#go(9)
nmap <Leader>0 <Plug>lightline#bufferline#go(10)

function! LightLineFilename()
  let name = ""
  let subs = split(expand('%:~'), "/")
  let i = 1
  for s in subs
    let parent = name
    if  i == len(subs) " last sub
      let name = parent . '/' . s
    elseif i == 1
      let name = s
    elseif s[0] == '.'
      let name = parent . '/' . s[0:1]
    else
      let name = parent . '/' . s[0]
    endif
    let i += 1
  endfor
  return name
endfunction

function! LightlineWebDevIcons(n)
  let l:bufnr = tabpagebuflist(a:n)[tabpagewinnr(a:n) - 1]
  return WebDevIconsGetFileTypeSymbol(bufname(l:bufnr))
endfunction

let g:tmuxline_powerline_separators = 0

let g:session_autosave = 'yes'
let g:session_autoload = 'yes'
let g:session_autosave_periodic = 1
let g:session_autosave_silent = 1
let g:session_default_name = substitute(getcwd(), "\/", "_", "g")
let g:session_default_overwrite = 1

let g:magit_discard_untracked_do_delete=1

" vim-choosewin config
" invoke with '-'
nmap  -  <Plug>(choosewin)
let g:choosewin_overlay_enable = 1

" markdown config

" disable header folding
let g:vim_markdown_folding_disabled = 1

" do not use conceal feature, the implementation is not so good
let g:vim_markdown_conceal = 0

" disable math tex conceal feature
let g:tex_conceal = ""
let g:vim_markdown_math = 1

" support front matter of various format
let g:vim_markdown_frontmatter = 1  " for YAML format
let g:vim_markdown_toml_frontmatter = 1  " for TOML format
let g:vim_markdown_json_frontmatter = 1  " for JSON format


" indent line config
let g:indentLine_char = '⎸'

" ##############
" # Lua Config #
" ##############

lua << EOF
require'lspconfig'.tsserver.setup{}
require'bufferline'.setup{
  options = {
    show_buffer_icons = false,
    tab_size = 10,
    diagnostics = "nvim_lsp",
  }
}
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    nvim_lsp = true;
  };
}

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  else
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
EOF


" ###############
" # KEY MAPPING #
" ###############

map <F2> :NERDTreeToggle<CR>
map <C-G> :Magit<CR>

" Switch tab
" nmap <S-Tab> :tabprev<Return>
" nmap <Tab> :tabnext<Return>

function! s:goyo_enter()
  set scrolloff=999
  Limelight
endfunction

function! s:goyo_leave()
  set scrolloff=0
  Limelight!
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" Telescope
nnoremap <leader>ff <cmd>Telescope git_files<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <silent> gb :BufferLinePick<CR>

map <C-t> :Telescope commands<CR>
map <C-x> :Telescope builtin<cr>
map <C-p> :Telescope git_files<cr>

