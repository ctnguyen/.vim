""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Author Chi Thanh Nguyen
"        chithanhnguyen.math@gmail.com
"
"        git@github.com:ctnguyen/.vim.git
"
" TOC
"   - General
"   - Keys mapping
"   - View (themes)
"   - Packages and Plugins
"
" TODO :
"   - Look at various vimrc on github, net to improve
"   - Test first in command mode before puting in vimrc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""""""""""""""""""""
" General
""""""""""""""""""""""""""""""""""""""""""""""""
" On windows, vim consider user VIM directory as $HOME/vimfiles
" To make it work for both gvim, batch vim as git-bash vim, it will need to
" create a symlink directory in windwos. Open cmd as administrator, run
"      mklink /D "C:\path\to\home_dir\vimfiles" "C:\path\to\home_dir\.vim"

" auto reload vimrc
autocmd! bufwritepost .vimrc source ~/.vim/vimrc
" print vim information
echom "Vim environments"
echom "."
echom "      $HOME="$HOME
echom "       $VIM="$VIM
echom "$VIMRUNTIME="$VIMRUNTIME
echom "   $MYVIMRC="$MYVIMRC
echom "."
echom "Vim loading ..."
scriptname

""""""""""""""""""""""""""""""""""""""""""""""""
" Keys mapping
""""""""""""""""""""""""""""""""""""""""""""""""
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

""""""""""""""""""""""""""""""""""""""""""""""""
" View (themes)
""""""""""""""""""""""""""""""""""""""""""""""""
" To know which terminal vim is runing, command :echo &term
" On windows batch, its win32, on gvim, it's builtin_gui. On linux, it's
" usually xterm or xterm-256color
" Color hightlighting for search and selection
" In PuTTY, need to set : 
"   - Window -> Apparance -> check Cursor blinks
"   - Connection -> Data -> set Terminal-type string to "xterm-256color"
"   - For shell/GitBash, check the environment variable TERM="xterm-256color"

" Always use spaces instead of tab
set expandtab ts=4 sw=4
syntax on

set hlsearch incsearch
hi Search ctermbg=DarkRed ctermfg=Black 
hi Visual ctermbg=DarkCyan ctermfg=Black
set cursorline
set number
hi CursorLine ctermbg=234 cterm=NONE
hi CursorLineNr ctermbg=234 cterm=NONE

" Cursor shape : https://vim.fandom.com/wiki/Change_cursor_shape_in_different_modes
let &t_SI="\e[5 q" "SI = INSERT mode        _ blink vertical bar
let &t_SR="\e[3 q" "SR = REPLACE mode       _ blink underscore
let &t_EI="\e[1 q" "EI = NORMAL mode (ELSE) _ blink block

" Set slate theme if use vim on windows
if has('win32')
  if has("gui_running")
    colorscheme evening
  else
    colorscheme slate
  endif
endif

set switchbuf=usetab,newtab "https://stackoverflow.com/questions/102384/using-vims-tabs-like-buffers


""""""""""""""""""""""""""""""""""""""""""""""""
" Packages
""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree : easy directory explorer
"    git clone https://github.com/preservim/nerdtree.git ~/.vim/pack/vendor/start/nerdtree ; vim -u NONE -c "helptags ~/.vim/pack/vendor/start/nerdtree/doc" -c q
map <C-n> :NERDTreeToggle<CR>
" lightline : nice statusline and tabline
"    git clone https://github.com/itchyny/lightline.vim ~/.vim/pack/plugins/start/lightline ; vim -u NONE -c "helptags ~/.vim/pack/plugins/start/lightline/doc" -c q
set laststatus=2

""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""""""""""""""""""""""""""
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


""""""""""""""""""""""""""""""""""""""""""""""""
" tags
""""""""""""""""""""""""""""""""""""""""""""""""
"ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extras=+q --language-force=C++ -f /home/chi/.vim/tags/boost_1_72_0 /home/chi/DevTools/boost_1_72_0"
"ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extras=+q --language-force=C++ -f /home/chi/.vim/tags/sv /home/chi/development/sv"
"ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extras=+q --language-force=C++ -f /home/chi/.vim/tags/bscrypt /home/chi/development/bscrypt"
set tags+=~/.vim/tags/boost_1_72_0
set tags+=~/.vim/tags/sv
set tags+=~/.vim/tags/bscrypt
set notagrelative
