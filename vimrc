" vimrc (forked from the default vimrc by Bram Moolenaar)
" Tyler Grunenwald | github.com/tdgrunenwald

" Set personal vim directory under ~/.config for consistency
" Requires $VIM_HOME to be set to desired location of user vim config
set runtimepath=$VIM_HOME,$VIMRUNTIME

if empty(glob('$VIM_HOME/autoload/plug.vim'))
	silent !curl -fLo $VIM_HOME/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin('$VIM_HOME/vim-plug')
Plug 'junegunn/goyo.vim'
call plug#end()

" Include global tags file in tags file search path
set tags=./tags,./TAGS,\tags,TAGS,$HOME/.config/vim/tags

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
" Avoid side effects when it was already reset.
if &compatible
  set nocompatible
endif

" Don't wait so long for mapped keys. Makes some things (e.g. pipe cursor ->
" block cursor transition after <ESC> from insert mode) snappier
set ttimeout
set ttimeoutlen=100

" Access clipboard via the unnamed register
set clipboard=autoselect,unnamedplus

" Formatting
set foldmethod=syntax
set tabstop=4
set shiftwidth=4
set noexpandtab
"set autoindent " should be set by filetype plugin
"set cindent
set textwidth=80

" Appearance
"set cursorline
set number
set showcmd
set ruler
set background=dark
set scrolloff=5

" Search behavior
set hlsearch
set incsearch

" Fuzzy find
set path+=**
set wildmenu

" Allow backspacing over everything in insert mode.
set backspace=start,eol,indent

" Syntax and filetype settings
syntax on
let c_comment_strings=1	" Highlight strings in C comments
filetype plugin indent on

" Jump to matching XML tags with %
if has('syntax') && has('eval')
  packadd! matchit
endif

" Fix common typos
nnoremap :Q :q
nnoremap :W :w

" Shortcut split navigation (save a keypress)
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Autocommands
if has("autocmd")
	augroup vimrc
		" Clear autocommands
		autocmd!

		" Add auto commands here...
	augroup END
endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig".
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" Set cursor to pipe in insert mode, underscore in replace mode, and block in normal mode.
" Sources:
" http://vim.wikia.com/wiki/Change_cursor_shape_in_different_modes
" https://vi.stackexchange.com/questions/3379/cursor-shape-under-vim-tmux
" https://vi.stackexchange.com/questions/7306/vim-normal-and-insert-mode-cursor-not-changing-in-gnu-screen
if &term == "screen" || &term == "screen-256color"
	let &t_SI = "\eP\e[6 q\e\\"
	let &t_SR = "\eP\e[4 q\e\\"
	let &t_EI = "\eP\e[2 q\e\\"
elseif &term == "tmux" || &term == "tmux-256color"
	let &t_SI = "\<esc>Ptmux;\<esc>\e[6 q\<esc>\\"
	let &t_SR = "\<esc>Ptmux;\<esc>\e[4 q\<esc>\\"
	let &t_EI = "\<esc>Ptmux;\<esc>\e[2 q\<esc>\\"
elseif &term != "linux"
	let &t_SI = "\e[6 q"
	let &t_SR = "\e[4 q"
	let &t_EI = "\e[2 q"
endif
