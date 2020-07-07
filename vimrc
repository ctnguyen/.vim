" To know which terminal vim is runing, command :echo &term
" On windows batch, its win32, on gvim, it's builtin_gui. On linux, it's
" usually xterm or xterm-256color
"
" To get this repository, go to home directory and clone from github
"    git clone https://github.com/ctnguyen/.vim.git
"
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

set expandtab
set ts=4 sw=4

set number

" Color hightlighting for search and selection
" In PuTTY, need to set : 
"   - Window -> Apparance -> check Cursor blinks
"   - Connection -> Data -> set Terminal-type string to "xterm-256color"
"   - For shell/GitBash, check the environment variable TERM="xterm-256color"
if &term == "builtin_gui"
    colorscheme slate
endif
syntax on
set hlsearch
set incsearch
hi Search ctermbg=DarkRed ctermfg=Black 
hi Visual ctermbg=DarkCyan ctermfg=Black
set cursorline
hi CursorLine ctermbg=234 cterm=NONE
hi CursorLineNr ctermbg=234 cterm=NONE

"ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extras=+q --language-force=C++ -f /home/chi/.vim/tags/boost_1_72_0 /home/chi/DevTools/boost_1_72_0"
"ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extras=+q --language-force=C++ -f /home/chi/.vim/tags/sv /home/chi/development/sv"
"ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extras=+q --language-force=C++ -f /home/chi/.vim/tags/bscrypt /home/chi/development/bscrypt"
set tags+=~/.vim/tags/boost_1_72_0
set tags+=~/.vim/tags/sv
set tags+=~/.vim/tags/bscrypt
set notagrelative

"== Cursor shape settings: https://vim.fandom.com/wiki/Change_cursor_shape_in_different_modes
let &t_SI="\e[5 q" "SI = INSERT mode        _ blink vertical bar
let &t_SR="\e[3 q" "SR = REPLACE mode       _ blink underscore
let &t_EI="\e[1 q" "EI = NORMAL mode (ELSE) _ blink block

set switchbuf=usetab,newtab "https://stackoverflow.com/questions/102384/using-vims-tabs-like-buffers


"" PACKAGES ---------------------------------
" NERDTree : easy directory explorer
"    git clone https://github.com/preservim/nerdtree.git ~/.vim/pack/vendor/start/nerdtree ; vim -u NONE -c "helptags ~/.vim/pack/vendor/start/nerdtree/doc" -c q
map <C-n> :NERDTreeToggle<CR>
" lightline : nice statusline and tabline
"    git clone https://github.com/itchyny/lightline.vim ~/.vim/pack/plugins/start/lightline ; vim -u NONE -c "helptags ~/.vim/pack/plugins/start/lightline/doc" -c q
set laststatus=2

"" PLUGINS ---------------------------------
" vim-plug : plugin manager
"    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" Then add plugin by 
"    - add to vimrc plugin session: Plug 'myplugin/path'
"    - open vimrc and run command :PlugInstall
call plug#begin('~/.vim/plugins')

" nerdcommenter : usefull function commenter
Plug 'preservim/nerdcommenter'

" ack : powerfull search tool
" install ack : cpan App::Ack
Plug 'mileszs/ack.vim'

" fzf : fuzzy finder 
" install fzf : git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf ; ~/.fzf/install
Plug 'junegunn/fzf.vim'

call plug#end()
