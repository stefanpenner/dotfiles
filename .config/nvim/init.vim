let mapleader = ','

set noswapfile
set nobackup
set nowritebackup

set clipboard=unnamed

call plug#begin()

Plug 'mbbill/undotree'
Plug 'Quramy/tsuquyomi'
Plug 'Raimondi/delimitMate'
Plug 'Shougo/vimproc.vim'
" Plug 'Valloric/YouCompleteMe'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'Yggdroot/indentLine'
Plug 'airblade/vim-gitgutter'
Plug 'bronson/vim-trailing-whitespace'
Plug 'chriskempson/base16-vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'majutsushi/tagbar'
Plug 'mileszs/ack.vim'
Plug 'mtth/scratch.vim'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'sbdchd/neoformat'
Plug 'scrooloose/nerdtree'
Plug 'sheerun/vim-polyglot'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'w0rp/ale'
Plug 'janko-m/vim-test'
Plug 'kassio/neoterm'

if has("unix")
  " this command seems slow..
  let s:uname = system("uname")
  if s:uname == "Darwin\n"
    Plug 'zerowidth/vim-copy-as-rtf'
  endif
endif

call plug#end()

let g:mustache_abbreviations = 1

let base16colorspace=256  " Access colors present in 256 colorspace
colorscheme base16-oceanicnext

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
set tabstop     =2
set softtabstop =2
set shiftwidth  =2
set expandtab
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
if has('nvim')
  function! R(command)
    call jobsend(g:repl_terminal_job, a:command . "\n")
  endfunction
else
  function! R(buf, command)
    " call jobsend(g:repl_terminal_job, a:command . "\n")
    call term_sendkeys(a:buf, a:command . "\<CR>")
  endfunction
end

function! Repl()
  term
  " e term://fish
  let g:repl_terminal_job = b:terminal_job_id
endfunction

nmap <Leader>ca <Plug>GitGutterStageHunk
nmap <Leader>cu <Plug>GitGutterRevertHunk

map <C-P> :Ag<cr>
map <C-F> :GFiles<cr>
map <C-B> :Buffers <cr>

autocmd FileType typescript nmap <buffer> <Leader>t : <C-u>echo tsuquyomi#hint()<CR>

set foldlevelstart=0
set foldnestmax=5

setlocal foldmethod=syntax
setlocal foldlevel=5
set cursorline
hi CursorLine   cterm=NONE ctermbg=233

highlight clear SignColumn      " SignColumn should match background
highlight clear LineNr          " Current line number row will have same background color in relative mode
set virtualedit=onemore

set wildmenu                    " Show list instead of just completing
set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
set scrolljump=5                " Lines to scroll when cursor leaves screen
set scrolloff=3                 " Minimum lines to keep above and below cursor
set foldenable                  " Auto fold code
set foldmarker={,}
set foldlevel=0
set foldmethod=marker
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace
set smartindent
set autoindent
set nojoinspaces

let g:indent_guides_auto_colors = 1

let g:terminal_scrollback_buffer_size=10000

noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

let g:gitgutter_async = 1
let g:tsuquyomi_tsserver_debug = 1

let g:tsuquyomi_completion_detail = 1
set completeopt+=preview

autocmd FileType typescript nmap <buffer> <Leader>t : <C-u>echo tsuquyomi#hint()<CR>

let g:auto_complete_start_length = 0
let g:goyo_width = "85%"

let g:scratch_persistence_file = ".scratch"
let g:scratch_autohide = 1

nnoremap <silent> <leader>q gwip

let g:airline#extensions#tabline#enabled = 1
let g:airline_section_y = '#%{bufnr("%")}'
let g:airline#extensions#tabline#enabled = 1

let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✗",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "y",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ "Unknown"   : "?"
    \ }

if exists('&inccommand')
  set inccommand=nosplit
endif

if has('mouse')
  set mouse=a
endif

" :syntime on
" :syntime report
syntax sync minlines=256
" set synmaxcol=128
set lazyredraw
if has('nvim')
  au TermOpen * setlocal nonumber norelativenumber
endif

autocmd FileType javascript setlocal formatprg=prettier\ --stdin\ --single-quote\ --trailing-comma\ es5
let g:neoformat_try_formatprg = 1

" Enable alignment
let g:neoformat_basic_format_align = 1

" Enable tab to spaces conversion
let g:neoformat_basic_format_retab = 1

" Enable trimmming of trailing whitespace
let g:neoformat_basic_format_trim = 1
let g:ale_linters = {
\   'javascript': ['eslint'],
\}

if executable('rg')
  let g:ackprg = 'rg --vimgrep'
elseif executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" stop using escape"
" inoremap <esc> <nop>

if has("gui_macvim")
  " disable all GUI scrollbars
  set guioptions=
  set macligatures
end

" set term=screen-256color
set t_Co=256
set background=dark
let base16colorspace=256        " Access colors present in 256 colorspace
" colorscheme base16-ocean
"
if has("persistent_undo")
  set undodir=~/.undodir/
  set undofile
endif

let test#strategy = "neoterm"
let g:test#javascript#mocha#file_pattern = '.*.js$'


