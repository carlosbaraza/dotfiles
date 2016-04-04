" Folding/Collapsin
set foldmethod=indent

" axim/vimrc
set runtimepath+=~/.vim_runtime

source ~/.vim_runtime/vimrcs/basic.vim
source ~/.vim_runtime/vimrcs/filetypes.vim
source ~/.vim_runtime/vimrcs/plugins_config.vim
source ~/.vim_runtime/vimrcs/extended.vim

try
source ~/.vim_runtime/my_configs.vim
catch
endtry

" Show line number
set number

" Angular html attributes scape in syntastic
let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]

" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

" Navigate through buffers like tabs
map <C-u> :bprevious<CR>
map <C-i> :bnext<CR>

" Poweline cool fonts
let g:airline_powerline_fonts = 1

" Hide duplicated mode bar (https://github.com/bling/vim-airline/issues/538)
set noshowmode
set cmdheight=1

" HTML5 for syntastic
let g:syntastic_html_tidy_exec = 'tidy5'

" Yank to clipboard (MacVim)
set clipboard=unnamed

" Folding overides
set foldmethod=indent
set foldlevel=20
set foldlevelstart=20
setl foldlevelstart=20
au FileType javascript call JavaScriptFold()
function! JavaScriptFold()
    setl foldlevelstart=20
endfunction

" Use two spaces indentation
set expandtab
set shiftwidth=2
set softtabstop=2

" Mutli cursor in ctrl-d like atom or sublime
let g:multi_cursor_next_key="\<C-d>"
let g:multi_cursor_quit_key=1

let NERDTreeShowHidden=1

" Show background change after character 80
let &colorcolumn=join(range(81,999),",")
highlight ColorColumn ctermbg=0

" Automatically remove trailing spaces
autocmd BufWritePre * :%s/\s\+$//e

" Dont remove indentation when doing ESC after new line.
inoremap <CR> <CR>x<BS>
nnoremap o ox<BS>
nnoremap O Ox<BS>
