let mapleader = ','
set backupdir=/private/tmp
set dir=/private/tmp
set clipboard=unnamed

call plug#begin()
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-unimpaired'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
" Plug 'Valloric/YouCompleteMe'
Plug 'moll/vim-node'
Plug 'editorconfig/editorconfig-vim'
Plug 'ervandew/supertab'
Plug 'Lokaltog/vim-powerline'
Plug 'terryma/vim-multiple-cursors'
Plug 'bogado/file-line'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-gitgutter'
Plug 'leafgarland/typescript-vim'
Plug 'bronson/vim-trailing-whitespace'
Plug 'mustache/vim-mustache-handlebars'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'rust-lang/rust.vim'
Plug 'pangloss/vim-javascript'
Plug 'lukerandall/haskellmode-vim'
Plug 'tpope/vim-repeat'
Plug 'Raimondi/delimitMate'
Plug 'Yggdroot/indentLine'
" Plug 'vim-scripts/javacomplete'
" Plug 'SirVer/ultisnips'
Plug 'elixir-lang/vim-elixir'
Plug 'chriskempson/base16-vim'
Plug 'dag/vim-fish'
Plug 'zerowidth/vim-copy-as-rtf'
call plug#end()
let g:mustache_abbreviations = 1

let base16colorspace=256  " Access colors present in 256 colorspace
colorscheme base16-default
set background=dark

" groups of letters with dashes as words
set iskeyword +=-
set binary

set tabstop     =2
set softtabstop =2
set shiftwidth  =2
set expandtab

au BufReadPost * set relativenumber

" ensure truecolor on doesn't tricky nerdtree into always openning
let g:nerdtree_tabs_open_on_gui_startup =0
set rtp+=/usr/local/Cellar/fzf/HEAD

function! StripWhitespace ()
  exec ':%s/ \+$//gc'
endfunction

map <leader>s :call StripWhitespace ()<CR>
map <leader>n :NERDTreeToggle<CR>

set nu

function! REPLSend(lines)
  call jobsend(g:repl_terminal_job, add(a:lines, ''))
endfunction

" :map ,r :w \| call R("rustc -o out " . @% . " ;and ./out")
function! R(command)
  call jobsend(g:repl_terminal_job, a:command . "\n")
endfunction

function! Repl()
  e term://fish
  let g:repl_terminal_job = b:terminal_job_id
endfunction

nmap <Leader>ca <Plug>GitGutterStageHunk
nmap <Leader>cu <Plug>GitGutterRevertHunk

function! s:fzf_statusline()
  " Override statusline as you like
  highlight fzf1 ctermfg=161 ctermbg=251
  highlight fzf2 ctermfg=23 ctermbg=251
  highlight fzf3 ctermfg=237 ctermbg=251
  setlocal statusline=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f
endfunction

autocmd! User FzfStatusLine call <SID>fzf_statusline()

map <C-P> :Ag<cr>
map <C-F> :FZF +c -m -x<cr>

autocmd FileType typescript nmap <buffer> <Leader>e <Plug>(TsuquyomiRenameSymbol)
autocmd FileType typescript nmap <buffer> <Leader>E <Plug>(TsuquyomiRenameSymbolC)

autocmd FileType typescript nmap <buffer> <Leader>a : <C-u>echo tsuquyomi#hint()<CR>

let g:typescript_compiler_options = "--target es5"
" let g:syntastic_typescript_tsc_args = '--target ES5'

" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*

" let g:syntastic_javascript_checkers = [ 'eslint', 'jshint' ]
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0

autocmd FileType typescript nmap <buffer> <Leader>t : <C-u>echo tsuquyomi#hint()<CR>

set foldlevelstart=0
set foldnestmax=5

setlocal foldmethod=syntax
setlocal foldlevel=5

let javaScript_fold=1         " JavaScript
let perl_fold=1               " Perl
let php_folding=1             " PHP
let r_syntax_folding=1        " R
let ruby_fold=1               " Ruby
let sh_fold_enabled=1         " sh
let vimsyn_folding='af'       " Vim script
let xml_syntax_folding=1      " XML

let g:indent_guides_auto_colors = 1
set smartindent
set autoindent

let g:haddock_browser="/Applications/Google Chrome Canary.app"

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
