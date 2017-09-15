" Vim plug auto installation
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
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
Plug 'w0rp/ale'

Plug 'airblade/vim-gitgutter'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive' " Git Commands
Plug 'jreybert/vimagit' " Magit
Plug 'ntpeters/vim-better-whitespace'
Plug 'tpope/vim-sleuth' " Auto detect indentation
Plug 'wakatime/vim-wakatime'
Plug 'tpope/vim-endwise'
Plug 'scrooloose/nerdcommenter' " Toggle comment
Plug 'tpope/vim-sensible' " General config
Plug 'moll/vim-bbye'
Plug 'mattn/emmet-vim'
Plug 'terryma/vim-multiple-cursors'

Plug 'xolox/vim-misc' " Session management
Plug 'xolox/vim-session' " Session management

Plug 'junegunn/goyo.vim'

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

" ###################
" # THEMES & COLORS #
" ###################

" Colorschemes
Plug 'ayu-theme/ayu-vim'
Plug 'junegunn/seoul256.vim'
Plug 'w0ng/vim-hybrid'

" Customization
" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'
Plug 'itchyny/lightline.vim'

Plug 'edkolev/tmuxline.vim'

" #######################################
" # LANGUAGE SERVER RECOMMENDED PLUGINS #
" #######################################

Plug 'autozimu/LanguageClient-neovim', { 'do': ':UpdateRemotePlugins' }
" (Optional) Multi-entry selection UI.

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tweekmonster/fzf-filemru'

" (Optional) Multi-entry selection UI.
Plug 'Shougo/denite.nvim'
" (Optional) Completion integration with deoplete.
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" (Optional) Completion integration with nvim-completion-manager.
Plug 'roxma/nvim-completion-manager'
" (Optional) Showing function signature and inline doc.
Plug 'Shougo/echodoc.vim'

call plug#end()

" ##########################
" # LANGUAGE SERVER CONFIG #
" ##########################

" Required for operations modifying multiple buffers like rename.
set hidden

let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'typescript': ['javascript-typescript-stdio'],
    \ 'vue': ['vls']
    \ }

" Automatically start language servers.
let g:LanguageClient_autoStart = 1

nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <S-F2> :call LanguageClient_textDocument_rename()<CR>

" #################
" # PLUGIN CONFIG #
" #################

let g:ale_linters = {
\   'javascript': ['standard'],
\}

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

let g:seoul256_background = 233
let g:seoul256_light_background = 256

let g:airline_theme='solarized'
let g:airline#extensions#tabline#enabled = 1
let g:airline_solarized_bg='dark'

let g:lightline = {
  \ 'colorscheme': 'seoul256',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'gitbranch', 'readonly', 'relativepath', 'modified' ] ]
  \ },
  \ 'component_function': {
  \   'gitbranch': 'fugitive#head',
  \ },
\ }

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

let g:tmuxline_powerline_separators = 0

let g:session_autosave = 'yes'
let g:session_autoload = 'yes'
let g:session_autosave_periodic = 1
let g:session_autosave_silent = 1
let g:session_default_name = substitute(getcwd(), "\/", "_", "g")
let g:session_default_overwrite = 1

let g:magit_discard_untracked_do_delete=1

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

filetype plugin on

if has("termguicolors")     " set true colors
  set t_8f=\[[38;2;%lu;%lu;%lum
  set t_8b=\[[48;2;%lu;%lu;%lum
  set termguicolors
endif

colorscheme seoul256

" ###############
" # KEY MAPPING #
" ###############

map <C-t> :Commands<CR>
map <C-x> :ProjectMru --tiebreak=end<cr>
map <C-s> :Buffers<cr>
map <C-p> :FilesMru --tiebreak=end<cr>
map <F2> :NERDTreeToggle<CR>
