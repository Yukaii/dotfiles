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
" Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive' " Git Commands
Plug 'jreybert/vimagit' " Magit
Plug 'ntpeters/vim-better-whitespace'
Plug 'tpope/vim-sleuth' " Auto detect indentation
Plug 'wakatime/vim-wakatime'
Plug 'tpope/vim-endwise'
Plug 'scrooloose/nerdcommenter' " Toggle comment
Plug 'tpope/vim-sensible' " General config

" ####################
" # LANGUAGE SUPPORT #
" ####################

" Syntax
Plug 'dag/vim-fish'
Plug 'editorconfig/editorconfig-vim'
Plug 'gisphm/vim-gitignore'
Plug 'nikvdp/ejs-syntax'
Plug 'PProvost/vim-ps1'
Plug 'tpope/vim-liquid'

Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'

" ###################
" # THEMES & COLORS #
" ###################

" Colorschemes
Plug 'ayu-theme/ayu-vim'

" Customization
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" #######################################
" # LANGUAGE SERVER RECOMMENDED PLUGINS #
" #######################################

Plug 'autozimu/LanguageClient-neovim', { 'do': ':UpdateRemotePlugins' }
" (Optional) Multi-entry selection UI.

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

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

let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let NERDTreeShowHidden=1

" ##################
" # GENERAL CONFIG #
" ##################

set number
set relativenumber
set cursorline
set mouse=a
set wrap
set linebreak

filetype plugin on

if has("termguicolors")     " set true colors
  set t_8f=\[[38;2;%lu;%lu;%lum
  set t_8b=\[[48;2;%lu;%lu;%lum
  set termguicolors
endif

let ayucolor="light"
let g:airline_theme='solarized'

colorscheme ayu

" ###############
" # KEY MAPPING #
" ###############

map <C-S-p> :Commands<CR>
map <M-p> :GFiles<CR>
map <F2> :NERDTreeToggle<CR>
