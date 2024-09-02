" Get the defaults that most users want.
" source $VIMRUNTIME/defaults.vim

" Recognise markdown files by .md extension.
autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=markdown

" Add automations for daily needs.
augroup WorkflowAutomations
    autocmd!

    " Before each write:
    autocmd BufWritePre *
        \ :call <SID>StripTrailingWhitespaces() |
        \ :call <SID>ReduceEmptyLines() |
        \ :call <SID>StripTrailingLines()

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

" MAPPINGS -----------------------------------------------------------------------

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
" TODO: Probably, replace with ls?
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
inoremap <C-[> <Esc>

" LAYOUT & SETTINGS ---------------------------------------------------------------

"set termguicolors

" External vim behaviour.
set autochdir               " Change current dir (same as open file).
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
set splitright      " Open new window to the right of the current one.
set splitbelow      " Open new window below the current one.

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
