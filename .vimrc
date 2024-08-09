" Plugin configuration
call plug#begin('~/.vim/bundle/')

" Plugin list
" Plug 'tpope/vim-fugitive'
Plug 'ajmwagar/vim-deus'
Plug 'pearofducks/ansible-vim'
Plug 'dense-analysis/ale'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'hashivim/vim-terraform'
" Plug 'JamshedVesuna/vim-markdown-preview'
call plug#end()

" Set the colorscheme
colorscheme deus

" Airline settings
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='deus'
let g:airline_powerline_fonts = 1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#hunks#enabled = 1
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'default'

" Basic settings
set laststatus=2
syntax on
filetype plugin indent on

" Python runner map
nmap <F4> <Esc>:w<CR>:!clear;python %<CR>

" YAML settings
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" General settings
set is hlsearch ai ic scs
nnoremap <esc><esc> :nohls<cr>
autocmd BufWritePre * if &filetype != 'markdown' | %s/\s\+$//e | endif

" Indentation settings
set tabstop=8
set expandtab
set shiftwidth=4
set autoindent
set smartindent
vnoremap <TAB> >gv
vnoremap <S-TAB> <gv

" Filetype settings
au BufRead,BufNewFile */infra_ansible/*.yml set filetype=yaml.ansible
au BufRead,BufNewFile */devops/*.yml set filetype=yaml.ansible

" ALE settings
let g:ale_linters = {'yaml': ['yamllint'], 'ansible': ['ansible-lint'], 'yaml.ansible': ['yamllint']}
let g:ale_ansible_ansible_lint_executable = 'ansible-lint'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
let g:ale_lint_on_text_changed = 'always'
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1
let g:ale_lint_delay = 0

" Clipboard settings
set clipboard=unnamedplus

" Custom search function
function! SearchWithContext(pattern, context)
    execute 'g/' . a:pattern . '/z ' . a:context
endfunction

command! -nargs=+ -complete=command SearchContext call SearchWithContext(<f-args>)

set nohlsearch

" Map Ctrl+F to call :Rg and show indication at the bottom bar
nnoremap <C-F> :call RgWithIndication()<CR>

function! RgWithIndication()
  " Display a message in the command line
  echo "Search with :Rg"
  " Call the :Rg command
  call feedkeys(":Rg ")
endfunction

" Function to get the current Git branch name
function! GitBranch()
  " Check if the current file is in a git repository
  if empty(glob('.git')) && empty(system('git rev-parse --show-toplevel'))
    return ''
  endif
  " Get the current branch name
  let l:branch = system('git rev-parse --abbrev-ref HEAD 2>/dev/null')
  return substitute(l:branch, '\n', '', 'g')
endfunction

" Set the status line
set statusline=%F\ %m\ %r\ %h\ %w\ [%{GitBranch()}]\ %y\ %=\ %l,%c\ %P
inoremap <c-b> <Esc>:Lex<cr>:vertical resize 30<cr>

" Enable automatic preview on cursor move
" let g:loaded_netrwPlugin = 1
let g:netrw_preview = 1
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_winsize = 25
" Define an augroup for netrw settings and mappings
augroup netrw_configs
  autocmd!
  " Map Right Arrow to open the directory or file under the cursor
  autocmd FileType netrw nmap <buffer> <Right> <CR>
  " Map Left Arrow to go to the parent directory
  autocmd FileType netrw nmap <buffer> <Left> u
  " Function and autocmd to ensure live preview
  autocmd FileType netrw autocmd CursorMoved,CursorMovedI <buffer> call NetrwLivePreview()
augroup END

" Function to ensure live preview
function! NetrwLivePreview()
    if g:netrw_preview
        execute 'normal! \<CR>'
    endif
endfunction

set mouse=a
