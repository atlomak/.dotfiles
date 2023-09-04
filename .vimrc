set nocompatible
nnoremap <SPACE> <Nop>
let mapleader = " "

let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

set ttimeout
set ttimeoutlen=1
set ttyfast

set incsearch
set backspace=indent,eol,start
set complete-=i

set relativenumber
set number

set expandtab
set tabstop=4
set sw=4

set signcolumn=yes

set hidden

set ignorecase
set smartcase

set mouse=a

"Func by xolox/stackoverflow
"Replace word under selected region
vnoremap <leader>r :call Get_visual_selection()<cr>

function! Get_visual_selection()
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  let selection = join(lines,'\n')
  let change = input('Change the selection with: ')
  execute ":%s/".selection."/".change."/gc"
endfunction

" TRUECOLORS
if (empty($TMUX) && getenv('TERM_PROGRAM') != 'Apple_Terminal')
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

"Install Plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


"git config --global core.autocrlf false -> ubuntu
call plug#begin()
Plug 'tpope/vim-vinegar'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vim-airline/vim-airline'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'vim-test/vim-test'
Plug 'Yggdroot/indentLine'
Plug 'hashivim/vim-terraform'
Plug 'moll/vim-bbye'
Plug 'junegunn/goyo.vim'
Plug 'tpope/vim-fugitive'
Plug 'puremourning/vimspector'
"Colorthemes
Plug 'rafi/awesome-vim-colorschemes'
call plug#end()

autocmd ColorScheme * hi CocUnusedHighlight ctermfg=Yellow guifg=#fab005
set background=dark
colorscheme gruvbox

"Buffers
nmap <silent> <tab> :bn<CR>
nmap <silent> <s-tab> :bp<CR>


"COC config

let g:coc_disable_startup_warning=1


nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
autocmd CursorHold * silent call CocActionAsync('highlight')

autocmd User CocNvimInit nmap <silent> gd <Plug>(coc-definition)
autocmd User CocNvimInit nmap <silent> gd <Plug>(coc-definition)
autocmd User CocNvimInit nmap <silent> gd <Plug>(coc-definition)
autocmd User CocNvimInit nmap <silent> gy <Plug>(coc-type-definition)
autocmd User CocNvimInit nmap <silent> gi <Plug>(coc-implementation)
autocmd User CocNvimInit nmap <silent> gr <Plug>(coc-references)
autocmd User CocNvimInit nmap <silent> <leader>rn <Plug>(coc-rename)
autocmd User CocNvimInit nmap <silent><nowait> <space>d  :CocDiagnostics<CR>

if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

command! -nargs=0 Format :call CocActionAsync('format')

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

"Airline
let g:airline#extensions#tabline#enabled = 1

" Nerdtree

nnoremap <leader>e :NERDTreeFocus<CR>

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

"Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif


"Vimtest
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>t :TestNearest<CR>

"IndentLine guides
let g:indentLine_enabled = 1


"GoYo

function! s:goyo_enter()
  :NERDTreeClose
  set noshowmode
  set noshowcmd
  set scrolloff=999
endfunction
autocmd! User GoyoEnter nested call <SID>goyo_enter()


" Vimspector
let g:vimspector_enable_mappings = 'HUMAN'
nmap <F1> :CocCommand java.debug.vimspector.start<CR>
