let mapleader = ','

set noswapfile
set nobackup
set nowritebackup
set clipboard=unnamed
set noendofline
set hidden

" vim-coc {{{
"" Better display for messages
set cmdheight=2
" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300
" don't give |ins-completion-menu| messages.
set shortmess+=c
" always show signcolumns
set signcolumn=yes
"}}}

" Vim Plugins - {{{
call plug#begin() 
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-function'
Plug 'kana/vim-textobj-fold'
Plug 'kana/vim-textobj-entire'
Plug 'glts/vim-textobj-comment'
Plug 'fvictorio/vim-textobj-backticks'
Plug 'thinca/vim-textobj-function-javascript'

Plug 'Raimondi/delimitMate'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'preservim/nerdtree'
Plug 'Yggdroot/indentLine'
Plug 'airblade/vim-gitgutter'
Plug 'bronson/vim-trailing-whitespace'
Plug 'chriskempson/base16-vim'
" Plug 'editorconfig/editorconfig-vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'mileszs/ack.vim'
Plug 'sheerun/vim-polyglot'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'janko-m/vim-test'
Plug 'kassio/neoterm'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
Plug 'othree/html5.vim'
Plug 'jparise/vim-graphql'
Plug 'sudar/vim-arduino-syntax'
Plug 'powerman/vim-plugin-AnsiEsc'
Plug 'darfink/vim-plist'
if has("unix")
  " this command seems slow..
  let s:uname = system("uname")
  if s:uname == "Darwin\n"
    Plug 'zerowidth/vim-copy-as-rtf'
  endif
endif

call plug#end()
" }}}

let g:mustache_abbreviations = 1

set termguicolors
let base16colorspace=256  " Access colors present in 256 colorspace
colorscheme base16-oceanicnext
"" groups of letters with dashes as words
set iskeyword +=-
set binary

au BufReadPost * set relativenumber

"" ensure truecolor on doesn't tricky nerdtree into always opening
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

map <C-P> :Rg<cr>
map <C-F> :FZF<cr>
map <C-B> :Buffers <cr>

set foldlevelstart=0
set foldnestmax=5

" setlocal foldmethod=syntax
" setlocal foldlevel=5
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
" set foldenable                  " Auto fold code
" set foldmarker={,}
" set foldlevel=0
" set foldmethod=marker
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
set completeopt+=preview

let g:auto_complete_start_length = 0
let g:goyo_width = "85%"

let g:scratch_persistence_file = ".scratch"
let g:scratch_autohide = 1

nnoremap <silent> <leader>q gwip

let g:airline#extensions#tabline#enabled = 1
let g:airline_section_y = '#%{bufnr("%")}'
let g:airline#extensions#tabline#enabled = 1

let g:NERDTreeGitStatusIndicatorMapCustom = {
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

" rely on local prettierrc for decent options like single quote, print width
" set formatprg = \"prettier --stdin --stdin-filepath \" . expand('%')
" autocmd FileType javascript setlocal formatprg=prettier\ --stdin\ --stdin-filepath expand('%')

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
" git aware fzf
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden'

let g:neoterm_autoinsert = 0
let g:neoterm_autoscroll = 1
let g:neoterm_default_mod = 'browse'
nmap gx <Plug>(neoterm-repl-send)
xmap gx <Plug>(neoterm-repl-send)
" 3<leader>tl will clear neoterm-3.
nnoremap <leader>tl :<c-u>exec v:count.'Tclear'<cr>
" vim-test ----{
nmap <silent> t<C-n> :TestNearest<CR> " t Ctrl+n
nmap <silent> t<C-f> :TestFile<CR>    " t Ctrl+f
nmap <silent> t<C-s> :TestSuite<CR>   " t Ctrl+s
nmap <silent> t<C-l> :TestLast<CR>    " t Ctrl+l
nmap <silent> t<C-g> :TestVisit<CR>   " t Ctrl+g

" let g:test#javascript#mocha#file_pattern = '\v.*.(ts|tsx)$'
" function! TypeScriptTransform(cmd) abort
"   return substitute(a:cmd, '\v(.*)mocha', 'env TS_NODE_FILES=true \1ts-mocha', '')
" endfunction
" let g:test#custom_transformations = {'typescript': function('TypeScriptTransform')}
" let g:test#transformation = 'typescript'

" --- }}}
let asmsyntax="nasm"

" Use `[c` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
let g:echodoc#enable_at_startup = 1
let g:echodoc#events = [ 'CursorMoved','CursorMovedI' ]

" Vimscript file settings ---------------------- {{{
augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}

" CoC config --- Use K to show documentation in preview window {{{
" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
nnoremap <silent> K :call <SID>show_documentation()<CR>

" Remap for do codeAction of selected region
function! s:cocActionsOpenFromSelected(type) abort
  execute 'CocCommand actions.open ' . a:type
endfunction
xmap <silent> <leader>a :<C-u>execute 'CocCommand actions.open ' . visualmode()<CR>
nmap <silent> <leader>a :<C-u>set operatorfunc=<SID>cocActionsOpenFromSelected<CR>g@
command! -nargs=0 Prettier :CocCommand prettier.formatFile

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
" Better display for messages
set cmdheight=2
" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes
" }}}