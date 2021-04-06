" LOAD PLUGINS {{{
    if 0 | endif
    if has('vim_starting')
        if &compatible
            set nocompatible
        endif
        set runtimepath+=~/.vim/bundle/neobundle.vim/
    endif
    call neobundle#begin(expand('~/.vim/bundle/'))
        NeoBundleFetch 'Shougo/neobundle.vim'
        NeoBundle 'L9'
        NeoBundle 'majutsushi/tagbar'
        NeoBundle 'ciaranm/detectindent'
        NeoBundle 'airblade/vim-gitgutter'
        NeoBundle 'tpope/vim-git'
        NeoBundle 'tpope/vim-fugitive'
        NeoBundle 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
        NeoBundle 'junegunn/fzf.vim'
        NeoBundle 'kshenoy/vim-signature'
        NeoBundle 'sjl/gundo.vim'
        NeoBundle 'HerringtonDarkholme/yats.vim'
        NeoBundle 'mileszs/ack.vim'
        NeoBundle 'junegunn/limelight.vim', { 'on': 'Limelight' }
    call neobundle#end()
    filetype plugin indent on
    NeoBundleCheck
" }}}

" APPEARANCE {{{
    syntax enable
    colorscheme ron
    set colorcolumn=79
    "let g:limelight_conceal_ctermfg = 'gray'
    "let g:limelight_priority = 0
    "autocmd VimEnter * Limelight
" }}}

" GENERAL {{{
    set encoding=utf-8
    set fileencodings=utf-8,latin2
    set lazyredraw
    set mouse=
    set number
    set laststatus=2
    set ruler
    set wildmenu
    set noshowmode
    set showmatch
    set title
    set showcmd
    set showmode
    set wildignore=*.swp,*.pdf,*.jpg,*.png,*.o
    set backupdir=~/tmp
    set directory=~/tmp
    set listchars=nbsp:¬,eol:¶,tab:→\ ,extends:»,precedes:«,trail:·
" }}}

" SEARCH {{{
    set hlsearch
    set ignorecase
    set smartcase
    set incsearch
    command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)
" }}}

" INDENT {{{
    set expandtab
    set tabstop=2
    set shiftwidth=2
    set backspace=indent,eol,start
    set autoindent
    set smartindent
    set smarttab
    set cindent
" }}}

" MAP SHORTCUTS {{{
    map <silent><leader><space> :nohlsearch<CR>
    map <silent><C-g> :TagbarToggle<CR>
    inoremap jj <ESC>
    nnoremap <silent><leader>u :GundoToggle<CR>
    tnoremap <ESC> <C-\><C-n>
" }}}

" PLUGINS {{{
    let g:gundo_preview_bottom=1
    " Remove whitespaces on save
    autocmd BufWritePre * :%s/\s\+$//e
    " Remember last position in file
    :au BufReadPost * if line("'\"") > 0 | if line("'\"") <= line("$") | exe("norm '\"") | else | exe("norm $") | endif | endif
    " User ripgrep for ack.vim
    if executable('rg')
      let g:ackprg = 'rg --vimgrep'
    endif
" }}}
