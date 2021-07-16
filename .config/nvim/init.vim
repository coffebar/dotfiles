set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

# statusline plugin init
lua require('lualine').setup {options = {icons_enabled = false}}
