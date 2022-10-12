set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz

"" reload nvim config automatically
if has("autocmd")
  au! BufWritePost ~/.vimrc source $MYVIMRC
  au! BufWritePost ~/.config/nvim/init.vim source $MYVIMRC
endif

"" airline options
let g:airline_theme='deus'
let g:airline#extensions#tabline#enabled = 1
let g:airline_section_z = "%p%% L:%l/%L C:%c"
let g:airline_powerline_fonts = 1

"" use deoplete - asynchronous completion
"" Note: install pynvim first
"" python3 -m pip install --user --upgrade pynvim
let g:deoplete#enable_at_startup = 1

set relativenumber

lua require('plugins')
