"e :args ~/src/myproject/**/*.ttl | argdo execute "normal gg=G" | update

set nocompatible              " be iMproved, required
filetype off                  " required
let mapleader = ','
set ttimeout
set ttimeoutlen=0

" tell vim to keep a backup file
set backup
" tell vim where to put its backup files
set backupdir=/private/tmp
" tell vim where to put swap files
set dir=/private/tmp

let g:ycm_seed_identifiers_with_syntax = 1
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
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}

" janus
Bundle 'kana/vim-textobj-user'
Bundle 'nelstrom/vim-textobj-rubyblock'
Bundle 'ervandew/supertab'
Bundle 'mileszs/ack.vim'
Bundle 'scrooloose/nerdtree'
Bundle 'terryma/vim-multiple-cursors'
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
Bundle 'godlygeek/tabular'
Bundle 'Valloric/YouCompleteMe'
Bundle 'benekastah/neomake'
"Bundle 'Raimondi/delimitMate'
Bundle 'tpope/vim-commentary'
Bundle 'tpope/vim-unimpaired'
Bundle 'rking/ag.vim'
" Bundle 'luochen1990/rainbow'
Bundle 'cespare/vim-toml'
Bundle 'terryma/vim-expand-region'
Bundle 'dag/vim-fish'
Bundle 'leafgarland/typescript-vim'
Plugin 'Quramy/tsuquyomi'
Plugin 'Shougo/vimproc.vim'

Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'

" Optional:
Plugin 'honza/vim-snippets'
" Theams
" Bundle 'jpo/vim-railscasts-theme'
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
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/bower_components/*,*/dist/*,*/vendor/*

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
tnoremap <c-g> <c-\><c-n>
tnoremap <c-a><c-a> REPLSendLine
set background=dark

nnoremap <silent> <f6> :REPLSendLine<cr>
vnoremap <silent> <f6> :REPLSendSelection<cr>

command! -range=% REPLSendSelection call REPLSend(s:GetVisual())
command! REPLSendLine call REPLSend([getline('.')])

function! REPLSend(lines)
  call jobsend(g:last_term_job_id, add(a:lines, ''))
endfunction

" :map ,r :w \| call R("rustc -o out " . @% . " ;and ./out")
function! R(command)
  call jobsend(g:last_term_job_id, a:command . "\n")
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

let g:rainbow_active = 1

let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'

let g:tagbar_type_javascript = {
    \ 'ctagsbin' : '/usr/local/bin/jsctags'
\ }

let g:gitgutter_max_signs = 5000
set iskeyword +=-
set binary
nmap <Leader>ca <Plug>GitGutterStageHunk
nmap <Leader>cu <Plug>GitGutterRevertHunk
"let g:SuperTabDefaultCompletionType = "context"


autocmd FileType typescript nmap <buffer> <Leader>e <Plug>(TsuquyomiRenameSymbol)
autocmd FileType typescript nmap <buffer> <Leader>E <Plug>(TsuquyomiRenameSymbolC)

autocmd FileType typescript nmap <buffer> <Leader>a : <C-u>echo tsuquyomi#hint()<CR>

"let g:ycm_add_preview_to_completeopt = 1
let g:ycm_min_num_of_chars_for_completion = 1
let g:ycm_complete_in_comments = 1
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_filepath_completion_use_working_dir = 1

let g:typescript_compiler_options = "--target es5"
let g:syntastic_typescript_tsc_args = '--target ES5'

autocmd FileType typescript nmap <buffer> <Leader>t : <C-u>echo tsuquyomi#hint()<CR>

" ensure truecolor on doesn't tricky nerdtree into always openning
let g:nerdtree_tabs_open_on_gui_startup =0
set rtp+=/usr/local/Cellar/fzf/HEAD

nnoremap <c-p> :FZF -m -x <cr>
nnoremap <c-l> :FZFLines<cr>

function! s:line_handler(l)
  let keys = split(a:l, ':\t')
  exec 'buf' keys[0]
  exec keys[1]
  normal! ^zz
endfunction

function! s:buffer_lines()
  let res = []
  for b in filter(range(1, bufnr('$')), 'buflisted(v:val)')
    call extend(res, map(getbufline(b,0,"$"), 'b . ":\t" . (v:key + 1) . ":\t" . v:val '))
  endfor
  return res
endfunction

command! FZFLines call fzf#run({
\   'source':  <sid>buffer_lines(),
\   'sink':    function('<sid>line_handler'),
\   'options': '--extended --nth=3..',
\   'down':    '60%'
\})
