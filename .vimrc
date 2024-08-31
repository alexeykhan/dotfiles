" Get the defaults that most users want.
" source $VIMRUNTIME/defaults.vim

au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown

" LAYOUT & SETTINGS --------------------------------------------------------------- 

"set termguicolors

" External vim behaviour.
set noswapfile              " Turns swapfiles off.
set nobackup                " Turns backup files off.
set undofile                " Turns undofiles on.
set undodir=~/.vim/undodir  " Sets directory for undo files.

" Internal vim settings.
set nowrap          " Do not wrap lines. Allow long lines to extend as far as the line goes.
set scrolloff=8     " Minimal number of screen lines to keep above and below the cursor.
set signcolumn=no   " Whether or not to draw the signcolumn.
set colorcolumn=80  " Highlighted column to align the text.
set updatetime=50   " If this many milliseconds nothing is typed the swap file will be written to disk.
set smartindent     " Automatic indenting based on code structure.
set history=1000    " Set the commands to save in history default number is 20.
set wildmenu        " Display completion matches in a status line

" Meta information about current scene.
set number          " Preceed each line with its line number. 
set relativenumber  " Show the line number relative to the line with the cursor. 
set ruler           " Show the line and column number of the cursor position
set showcmd         " Show (partial) command in the last line of the screen.

" Cursor settings.
set guicursor=
set nocursorline
set nocursorcolumn

" Tabulation settings.
set tabstop=4     " Set tab width to 4 columns.
set softtabstop=4 " Number of spaces inside INSERT mode.
set shiftwidth=4  " Default shift width for auto indenting. 
set expandtab     " Use space characters instead of tabs.
 
" SEARCH --------------------------------------------------------------------------- 

set ignorecase	" Ignore case while searching.
set smartcase   " Override the ignorecase option if searching for capital letters.

set incsearch   " Show search results while typing query. 
set nohlsearch

" FILETYPE & SYNTAX HIGHLIGHTING ------------------------------------------------- 

syntax on           " Set syntax highlight.
filetype on         " Enable type file detection.
filetype plugin on  " Enable plugins and load plugin for the detected file type.
filetype indent on  " Load an indent file for the detected file type.

" MAPPINGS -----------------------------------------------------------------------

" NORMAL MODE

" Set custom <leader> instead of \.
" Make sure spacebar doesn't have any mapping beforehand.
nnoremap <Space> <Nop>
let mapleader=" "

" Open path view (file manager, explorer).
" TODO: Probably, replace with ls?
nnoremap <leader>pv :Ex<CR>

" Delete without replacing current buffer!
nnoremap <leader>d "_d

" Copy directly to clipboard for export.
nnoremap <leader>y "+y
nnoremap <leader>Y "+Y

" Paste directly from clipboard.
nnoremap <leader>p "+p
nnoremap <leader>P "+P

" Center cursor after searches, half-page scrolls, line joins.
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap J mzJ`z

" VISUAL MODE
"   x - visual, visual-line, visual-block
"   v - visual, visual-line

" Replace selected text with buffer contents without replacing buffer.
xnoremap <leader>p "_dP

" Select lines and move them up/down with K/J.
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" INSERT MODE.

" Exit insert mode.
inoremap <C-c> <Esc>
inoremap <C-[> <Esc>
 


