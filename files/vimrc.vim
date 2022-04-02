set nocompatible

colorscheme evening

if has('filetype')
  filetype indent plugin on
endif

if has('syntax')
  syntax on
endif


set hidden
set wildmenu
set showcmd
set hlsearch


set ignorecase
set smartcase

set backspace=indent,eol,start
set autoindent
set nostartofline
set ruler
set laststatus=2
set confirm
set visualbell

if has('mouse')
  set mouse=a
endif

set cmdheight=2


set notimeout ttimeout ttimeoutlen=200
set pastetoggle=<F11>


set shiftwidth=2
set softtabstop=2
set expandtab


map Y y$
nnoremap <C-L> :nohl<CR><C-L>
