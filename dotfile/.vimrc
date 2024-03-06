"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" My vim setup
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Reference 1: https://github.com/amix/vimrc/blob/master/vimrcs/basic.vim
" Reference 2: https://github.com/WilsonQ1n/VIM_C_IDE
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vundle
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Theme: vim-one
Plugin 'rakr/vim-one'

" remove trailing whitespace
Plugin 'https://github.com/ntpeters/vim-better-whitespace'

" vim-powerline: better status line
Plugin 'https://github.com/Lokaltog/vim-powerline'

" Nerdtree
Plugin 'preservim/nerdtree'

" gutentags
Plugin 'ludovicchabant/vim-gutentags'

" Syntastic
Plugin 'scrooloose/syntastic'

"vim-sleuth
Plugin 'tpope/vim-sleuth'

call vundle#end()            " required
filetype plugin indent on    " required

" Usage: Type :PlugInstall to install plugins

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

" Enable filetype plugins
filetype plugin on
filetype indent on
filetype plugin indent on


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Enable syntax highlighting
syntax enable
syntax on

" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

" color setting
let g:airline_theme='one'
colorscheme one
set background=dark

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Always show line number
set number

" Always show cursoe line/column
set cursorline
set cursorcolumn

" Always show current position
set ruler

" No annoying sound on errors
set t_vb=

" Show (partial) command in status line.
set showcmd

" Show matching brackets.
set showmatch

" Do case insensitive matching
set ignorecase

" Do smart case matching
set smartcase

" Incremental search
set incsearch

" Highlight search
set hlsearch

" Hide buffers when they are abandoned
set hidden

" Enable mouse usage (all modes)
set mouse=a

" use vim default clipboard
" https://www.cnblogs.com/huahuayu/p/12235242.html
" Make sure vim support cliboard:
" > vim --version | grep \"clipboard\"
" +clipboard: support clipboard
" -clipboard: not support clipboard. Install gvim will solve the issue
set clipboard^=unnamed,unnamedplus

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Turn backup off, since most stuff is in SVN, git etc. anyway...
set nobackup
set nowb
set noswapfile


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" Be smart indent when entering a new line
set smartindent

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

" Remove trailling space
"autocmd BufWritePre * EnableStripWhitespaceOnSave
autocmd BufWritePre * :%s/\s\+$//e

""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2
" Format the status line
set statusline=\ %<%F[%1*%M%*%n%R%H]%=\ %y\ %0(%{&fileformat}\ %{&encoding}\ Ln\ %l,\ Col\ %c/%L%)
"set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c


""""""""""""""""""""""""""""""
" => MISC
""""""""""""""""""""""""""""""

" Additional setup
"set bufhidden=hide

" No error bells
set noerrorbells
set novisualbell

" auto change the directory to current directory
"set autochdir

" Enable spell check
set spell
set spell spelllang=en_us

" Enable fold
"set foldenable
"set foldmethod=syntax
"set foldcolumn=0
"setlocal foldlevel=1
" Use space to turn on/off fold
"nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>

""""""""""""""""""""""""""""""
" => Plugin Setup
""""""""""""""""""""""""""""""

"NERD Tree
nmap <Leader>fl :NERDTreeToggle<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
let NERDTreeWinSize=32
let NERDTreeShowHidden=1
let NERDTreeMinimalUI=1
let NERDTreeAutoDeleteBuffer=1

"gutentags
"Reference: https://zhuanlan.zhihu.com/p/43671939
" search for the project root directory, when it find these directory, stop searching upward
let g:gutentags_project_root = ['.root', '.svn', '.git', '.project']

" The name for the generate tags file
let g:gutentags_ctags_tagfile = '.tags'

" Put the generated tags into ~/.cache/tags directory
let s:vim_tags = expand('~/.cache/tags')
let g:gutentags_cache_dir = s:vim_tags

" Create ~/.cache/tags if it does not exist
if !isdirectory(s:vim_tags)
   silent! call mkdir(s:vim_tags, 'p')
endif

