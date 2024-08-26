
" An example for a vimrc file.
"
" Maintainer:	The Vim Project <https://github.com/vim/vim>
" Last Change:	2023 Aug 10
" Former Maintainer:	Bram Moolenaar <Bram@vim.org>
"
" To use it, copy it to
"	       for Unix:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"	 for MS-Windows:  $VIM\_vimrc
"	      for Haiku:  ~/config/settings/vim/vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings, bail
" out.
if v:progname =~? "evim"
  finish
endif

" Get the defaults that most users want.
source $VIMRUNTIME/defaults.vim

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file (restore to previous version)
  if has('persistent_undo')
    set undofile	" keep an undo file (undo changes after closing)
  endif
endif

if &t_Co > 2 || has("gui_running")
  " Switch on highlighting the last used search pattern.
  set hlsearch
endif

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78
augroup END

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
  packadd! matchit
endif


" LAYOUT & SETTINGS --------------------------------------------------------------- 

" Turn hybrid line numbers on (cursor absolute, other relative)
set number 
set relativenumber
set nocursorline
set nocursorcolumn

" Show cursor line, column, %.
set ruler       
set showcmd

" Set tab width to 4 columns.
set tabstop=4

" Use space characters instead of tabs.
set expandtab
 
" Do not wrap lines. Allow long lines to extend as far as the line goes.
set nowrap

" Set the commands to save in history default number is 20.
set history=1000

" Display completion matches in a status line.
set wildmenu

" SEARCH --------------------------------------------------------------------------- 

" Ignore case while searching.
set ignorecase		

" Override the ignorecase option if searching for capital letters.
" This will allow you to search specifically for capital letters.
set smartcase

" Show search results while typing query. 
set incsearch   
set nohlsearch

" FILETYPE & SYNTAX HIGHLIGHTING ------------------------------------------------- 

" Enable type file detection. Vim will be able to try to detect the type of file in use.
filetype on

" Enable plugins and load plugin for the detected file type.
filetype plugin on

" Load an indent file for the detected file type.
filetype indent on

" Set syntax highlight.
if has("syntax")
	syntax on
endif

" MAPPINGS -----------------------------------------------------------------------

" Center cursor after half-page scrolls.
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
