set nocompatible              " be iMproved, required
filetype off                  " required
let mapleader = ','

" set the runtime path to include Vundle and initialize
set rtp+=~/.nvim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
" plugin from http://vim-scripts.org/vim/scripts.html
" Git plugin not hosted on GitHub
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.

Bundle 'gmarik/vundle'
Bundle 'L9'
Bundle 'FuzzyFinder'
Bundle 'tomtom/tlib_vim'
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}

" janus
Bundle 'kana/vim-textobj-user'
Bundle 'MarcWeber/vim-addon-mw-utils'
Bundle 'garbas/vim-snipmate'
Bundle 'nelstrom/vim-textobj-rubyblock'
Bundle 'honza/vim-snippets'
Bundle 'ervandew/supertab'
Bundle 'kien/ctrlp.vim'
Bundle 'mileszs/ack.vim'
Bundle 'scrooloose/nerdtree'
Bundle 'terryma/vim-multiple-cursors'
Bundle 'tpope/vim-eunuch'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-rake'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-sensible'
Bundle 'tpope/vim-surround'
Bundle 'Lokaltog/vim-powerline'
Bundle 'airblade/vim-gitgutter'
Bundle 'cakebaker/scss-syntax.vim'
Bundle 'kchmck/vim-coffee-script'
Bundle 'pangloss/vim-javascript'
Bundle 'slim-template/vim-slim'
Bundle 'tpope/vim-git'
Bundle 'tpope/vim-markdown'
Bundle 'vim-ruby/vim-ruby'
Bundle 'mustache/vim-mustache-handlebars'
Bundle 'wting/rust.vim'
Bundle 'elixir-lang/vim-elixir'
Bundle 'jpalardy/vim-slime'
Bundle 'scrooloose/syntastic'
Bundle 'editorconfig/editorconfig-vim'
Bundle 'andreimaxim/vim-io'
Bundle 'moll/vim-node'

let g:slime_target = "tmux"
" Theams
Bundle 'jpo/vim-railscasts-theme'
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"

set hlsearch " Highlight searches
set incsearch " Do incremental searching
set expandtab
set tabstop=2 shiftwidth=2 softtabstop=2
set autoindent
set history=200000
set showcmd
set wrap
" set cryptmethod=blowfish
set wildignore+=*.png,*.jpg,*.gif,*.ai,*.jpeg,*.psd,*.swp,*.jar,*.zip,*.gem,.DS_Store,log/**,tmp/**,coverage/**,rdoc/**,output_*,*.xpi,doc/**
set wildmode=longest:full,list:full
set completeopt=menu,preview

map <silent><F8> :NERDTree<CR>
map <tab> :tabn<CR>
map <D-P> :NERDTreeToggle<CR>
map vv :CtrlP<CR>
:imap jj <Esc>

command! -complete=shellcmd -nargs=+ B call s:RunShellCommand(<q-args>)
function! s:RunShellCommand(cmdline)
  echo a:cmdline
  let expanded_cmdline = a:cmdline
  for part in split(a:cmdline, ' ')
    if part[0] =~ '\v[%#<]'
      let expanded_part = fnameescape(expand(part))
      let expanded_cmdline = substitute(expanded_cmdline, part, expanded_part, '')
    endif
  endfor
  botright new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  call setline(1, 'You entered:    ' . a:cmdline)
  call setline(2, 'Expanded Form:  ' .expanded_cmdline)
  call setline(3,substitute(getline(2),'.','=','g'))
  execute '$read !'. expanded_cmdline
  setlocal nomodifiable
  1
endfunction
nnoremap Q <nop>
"let g:ackprg = 'ag %s -i --nocolor --nogroup --ignore ''.git'' --ignore ''.DS_Store'' --ignore ''node_modules'' --hidden -g ""'
let g:ackprg = 'ag --vimgrep'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/bower_components/*,*/dist/*,*/node_modules/*,*/vendor/*

let g:mustache_abbreviations = 1
let mapleader = ','
set noswapfile
"common typos
iabbrev function function

nnoremap <leader><space> :noh<cr>
nnoremap <leader>d :REPLSendLine<cr>
set t_Co=256

function! ToggleNuMode()
  if(&rnu == 1)
    set nu
  else
    set rnu
  endif
endfunction
nnoremap <leader>b :call ToggleNuMode()<CR>
set nu

function! StripWhitespace ()
  exec ':%s/ \+$//gc'
endfunction

map <leader>s :call StripWhitespace ()<CR>
map <leader>n :NERDTreeToggle<CR>

au BufReadPost * set relativenumber
syntax enable

set clipboard=unnamed
if has('mouse')
  set mouse=a
endif
command RemoveMultipleBlankLines %s/^\(\s*\n\)\+/\r


set listchars=tab:▸\ ,eol:¬,trail:.,nbsp:%
set list
let base16colorspace=256  " Access colors present in 256 colorspace
colorscheme  base16-default
tnoremap <c-t> <c-\><c-n>
tnoremap <c-a><c-a> REPLSendLine
set background=dark

nnoremap <silent> <f6> :REPLSendLine<cr>
vnoremap <silent> <f6> :REPLSendSelection<cr>

command! -range=% REPLSendSelection call REPLSend(s:GetVisual())
command! REPLSendLine call REPLSend([getline('.')])

function! REPLSend(lines)
  call jobsend(g:last_term_job_id, add(a:lines, ''))
endfunction

function! s:GetVisual()
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][:col2 - 2]
  let lines[0] = lines[0][col1 - 1:]
  return lines
endfunction

au TermOpen * let g:last_term_job_id = b:terminal_job_id
