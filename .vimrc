" Get the defaults that most users want.
" source $VIMRUNTIME/defaults.vim

" AUTOMATIONS --------------------------------------------------------------

" Install plug.vim if not installed yet.
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    " Download plug.vim.
    silent execute '!curl -fLo ' . data_dir . '/autoload/plug.vim --create-dirs '
        \ . 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

    " Install plugins.
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Add automations for daily needs.
augroup Workspace
    autocmd!

    " Gruvbox transparent_bg conflicts with termguicolors.
    autocmd ColorScheme *
        \ highlight Normal ctermbg=NONE guibg=NONE |
        \ highlight NonText ctermbg=NONE guibg=NONE

    " Recognise markdown files by .md extension.
    autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=markdown

    " Before each write:
    autocmd BufWritePre *
        \ :call <SID>StripTrailingWhitespaces() |
        \ :call <SID>ReduceEmptyLines() |
        \ :call <SID>StripTrailingLines() |
        \ :retab " Turn existing tabs into spaces

augroup END

" Trim whitespaces at the end of each line.
" Keep cursor on the same position after substituion.
function! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfunc

" Replace multiple consecutive empty lines with single one.
" Keep cursor on the same position after substituion.
function! <SID>ReduceEmptyLines()
    let l = line(".")
    let c = col(".")
    %s/\(\n\s*\)\{3,}/\r\r/e
    call cursor(l, c)
endfunc

" Strip trailing lines.
"   1. Move the end of file;
"   2. Search backwards for the first line with non-whitespace characters,
"      that has a line break with any number of trailing spaces;
"   3. Delete everything from this line to the end of file;
function! <SID>StripTrailingLines()
    let l = line(".")
    let c = col(".")
    " Edge case: when the last line is not empty, script will delete
    " previous empty line - above the current non-empty line.
    " So just add one empty line to the end of file beforehand.
    call append('$', '')
    norm! G
    ?\S\+?,$s/\(\n\s*\)\{2,}//ge
    call cursor(l, c)
endfunc

" Get current filepath.
" If git repository: relative to repository root.
" If inside home directory: relative to home.
" Otherwise, absolute from root.
function! LightlineFilename()
    let filepath = expand('%:p')
    let gitpath = fnamemodify(get(b:, 'gitbranch_path'), ':h:h')
    if filepath[:len(gitpath)-1] ==# gitpath
        return filepath[len(gitpath)+1:]
    endif
    if filepath[:len($HOME)-1] ==# $HOME
        return '~/' . filepath[len($HOME)+1:]
    endif
    return filepath
endfunc

" PLUGINS -------------------------------------------------------------------

" Install plugins.
call plug#begin()
" -------------------------- Status / tab line.
Plug 'itchyny/lightline.vim'
Plug 'itchyny/vim-gitbranch'
" -------------------------- Syntax highlighting.
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
" -------------------------- Color schemes.
 Plug 'morhetz/gruvbox'
" Plug 'rose-pine/vim'
" Plug 'catppuccin/vim', { 'as': 'catppuccin' }
call plug#end()

" GLOBAL VARIABLES ------------------------------------------------------------

" `lightline` options.
let g:lightline = {
    \ 'colorscheme': 'one',
    \ 'tabline': {
    \   'left': [['tabs']],
    \   'right': []
    \ },
    \ 'active': {
    \   'left': [
    \     ['mode', 'paste'],
    \     ['gitbranch', 'filename', 'readonly', 'modified']],
    \   'right': [
    \     ['lineinfo'],
    \     ['percent']]
    \ },
    \ 'inactive': {
    \   'left': [['filename']],
    \   'right': [['lineinfo'], ['percent']]
    \ },
    \ 'component_function': {
    \   'gitbranch': 'gitbranch#name',
    \   'filename': 'LightlineFilename',
    \ },
    \ }

" Support italic escape codes.
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"

" `rose-pine` options.
let g:disable_bg = 1
let g:disable_float_bg = 1

" `gruvbox` options.
let g:gruvbox_bold=1
let g:gruvbox_italic=1
let g:gruvbox_invert_selection=0
let g:gruvbox_contrast_dark='hard'
let g:gruvbox_contrast_light='medium'

" `vim-go` options.
let g:go_highlight_build_constraints = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_array_whitespace_error = 1
let g:go_highlight_trailing_whitespace_error = 1
let g:go_highlight_chan_whitespace_error = 1
let g:go_highlight_space_tab_error = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_variable_declarations = 1
let g:go_highlight_variable_assignments = 1
let g:go_highlight_types = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1

" LAYOUT & SETTINGS ---------------------------------------------------------------

" Color schemes should be loaded after plug#end().
" Prepend it with 'silent!' to ignore errors when it's not yet installed.
silent! colorscheme gruvbox " rosepine / gruvbox

" Syntax highlighting.
syntax on           " Set syntax highlight.
filetype on         " Enable type file detection.
filetype plugin on  " Enable plugins and load plugin for the detected file type.
filetype indent on  " Load an indent file for the detected file type.

" Cursor settings.
set guicursor=
set cursorline
set nocursorcolumn

" External vim behaviour.
set autochdir               " Change current dir (same as open file).
set noswapfile              " Turns swapfiles off.
set nobackup                " Turns backup files off.
set undofile                " Turns undofiles on.
set undodir=~/.vim/undodir  " Sets directory for undo files.

" Internal vim settings.
set termguicolors   " Enable terminal colors.
set background=dark " Set dark theme background.
set nowrap          " Do not wrap lines. Allow long lines to extend.
set scrolloff=8     " Number of screen lines to keep above and below the cursor.
set signcolumn=no   " Whether or not to draw the signcolumn.
set colorcolumn=80  " Highlighted column to align the text.
set updatetime=50   " Write swap file after this number of ms nothing changed.
set smartindent     " Automatic indenting based on code structure.
set history=1000    " Set the commands to save in history default number is 20.
set wildmenu        " Display completion matches in a status line
set splitright      " Open new window to the right of the current one.
set splitbelow      " Open new window below the current one.

" Meta information about current scene.
set laststatus=2    " Always show a status line.
set number          " Preceed each line with its line number.
set relativenumber  " Show the line number relative to the line with the cursor.
set ruler           " Show the line and column number of the cursor position
set showcmd         " Show (partial) command in the last line of the screen.

" Tabulation settings.
set tabstop=4     " Set tab width to 4 columns.
set softtabstop=4 " Number of spaces inside INSERT mode.
set shiftwidth=4  " Default shift width for auto indenting.
set expandtab     " Use space characters instead of tabs.

" Search settings.
set ignorecase  " Ignore case while searching.
set smartcase   " Override ignorecase option when searching for capital letters.
set incsearch   " Show search results while typing query.
set nohlsearch

" MAPPINGS --------------------------------------------------------------------

" Make sure spacebar doesn't have any mapping beforehand.
" Set custom <leader> instead of \.
nnoremap <Space> <Nop>
let mapleader=" "

" Do not enter EX mode, ever.
nnoremap Q <Nop>

" Shortcuts for :commands.
nnoremap <leader>q :q
nnoremap <leader>w :w<CR>
nnoremap <leader>r :source $MYVIMRC<CR>
nnoremap <leader>ms :mksession! ~/.vim/sessions/
nnoremap <leader>ss :source ~/.vim/sessions/

" Open path view (file manager, explorer).
nnoremap <leader>pv :Ex<CR>

" Delete without replacing current buffer!
nnoremap <leader>d "_d
vnoremap <leader>d "_d

" Copy directly to system clipboard for export.
vnoremap <leader>y "+y
nnoremap <leader>y "+y
vnoremap <leader>Y "+Y
nnoremap <leader>Y "+Y

" Paste directly from system clipboard.
vnoremap <leader>p "+p
nnoremap <leader>p "+p
vnoremap <leader>P "+P
nnoremap <leader>P "+P

" Replace selected text with buffer contents without replacing buffer.
xnoremap <leader>dp "_dp
xnoremap <leader>dP "_dP

" Center cursor after searches, half-page scrolls, line joins.
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap J mzJ`z

" Select lines and move them up/down with K/J.
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Exit insert mode.
inoremap <C-c> <Esc>
