let mapleader = ','

set noswapfile
set nobackup
set nowritebackup
set clipboard=unnamed
set noendofline

call plug#begin()

Plug 'ervandew/supertab'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-function'
Plug 'kana/vim-textobj-fold'
Plug 'kana/vim-textobj-entire'
Plug 'glts/vim-textobj-comment'
Plug 'fvictorio/vim-textobj-backticks'
Plug 'thinca/vim-textobj-function-javascript'
Plug 'Shirk/vim-gas'

Plug 'mattn/webapi-vim'
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
Plug 'hellerve/carp-vim'
Plug 'rizzatti/dash.vim'
Plug 'racer-rust/vim-racer'
Plug 'statox/vim-compare-lines'
Plug 'vitalk/vim-simple-todo'
" Plug 'roxma/nvim-completion-manager'
" Plug 'roxma/nvim-cm-tern',  {'do': 'npm install'}
" Plug 'roxma/ncm-github'

" if has('nvim')
"  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" else
"   Plug 'Shougo/deoplete.nvim'
" endif

" Plug 'roxma/nvim-yarp'
" Plug 'roxma/vim-hug-neovim-rpc'

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

au BufReadPost * set relativenumber

" ensure truecolor on doesn't tricky nerdtree into always openning
let g:nerdtree_tabs_open_on_gui_startup =0
set rtp+=/usr/local/Cellar/fzf/HEAD
set tabstop     =2
set softtabstop =2
set shiftwidth  =2
set expandtab
filetype plugin indent on

function! StripWhitespace ()
  exec ':%s/ \+$//gc'
endfunction

map <leader>s :call StripWhitespace ()<CR>
map <leader>n :NERDTreeToggle<CR>

set nu

nmap <Leader>ca <Plug>GitGutterStageHunk
nmap <Leader>cu <Plug>GitGutterRevertHunk

map <C-P> :Ag<cr>
map <C-F> :FZF<cr>
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

let g:deoplete#enable_at_startup = 1
let g:nvim_typescript#javascript_support = 1
let g:ale_fixers = {
\ 'javascript': [
\   'prettier',
\   'eslint',
\ ],
\}

let g:racer_experimental_completer = 1
au FileType rust nmap gd <Plug>(rust-def)
au FileType rust nmap gs <Plug>(rust-def-split)
au FileType rust nmap gx <Plug>(rust-def-vertical)
au FileType rust nmap <leader>gd <Plug>(rust-doc)

" Put the fzf window to the right to not interfere with terminals (which i
" keep on the left)
let g:fzf_layout = {
\   'right': '~40%'
\}

let g:neoterm_autoinsert = 0
let g:neoterm_autoscroll = 1
let g:neoterm_default_mod = 'browse'
nmap gx <Plug>(neoterm-repl-send)
xmap gx <Plug>(neoterm-repl-send)
" 3<leader>tl will clear neoterm-3.
nnoremap <leader>tl :<c-u>exec v:count.'Tclear'<cr>

" vim-test
nmap <silent> t<C-n> :TestNearest<CR> " t Ctrl+n
nmap <silent> t<C-f> :TestFile<CR>    " t Ctrl+f
nmap <silent> t<C-s> :TestSuite<CR>   " t Ctrl+s
nmap <silent> t<C-l> :TestLast<CR>    " t Ctrl+l
nmap <silent> t<C-g> :TestVisit<CR>   " t Ctrl+g


let asmsyntax="nasm"

autocmd FileType typescript setlocal completeopt+=preview,menuone,longest

let g:SuperTabDefaultCompletionType = "<c-x><c-o>"

augroup FileType typescript autocmd BufNewFile,BufRead *.ts set filetype=typescript
   autocmd FileType typescript set tabstop=2 shiftwidth=2 expandtab
   autocmd CursorMoved,CursorMovedI *.ts :call TSWriteToPreview(tsuquyomi#hint())

  function TSWriteToPreview(content)
    if a:content ==# "[Tsuquyomi] There is no hint at the cursor."
      " pclose
    else

      set splitbelow
      set previewheight=4 " strdisplaywidth(a:content)
      silent pedit __TsuquyomiScratch__
      silent wincmd P
      setlocal modifiable noreadonly
      setlocal nobuflisted buftype=nofile bufhidden=wipe ft=typescript
      put =a:content
      0d_
      setlocal nomodifiable readonly
      silent wincmd p
    endif
  endfunction
augroup END

