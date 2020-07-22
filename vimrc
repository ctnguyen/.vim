""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Author Chi Thanh Nguyen
"        chithanhnguyen.math@gmail.com
"
"        git@github.com:ctnguyen/.vim.git
"
" TOC
"   - General
"   - Tab_management
"   - View_(themes)
"   - Packages_and_Plugins
"   - Keys_mapping
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
"
" print vim information. :echo VimEnv() to see all information here
function! VimEnv()
  let str_val="Vim environments\n"
  let str_val=join([str_val,join(["      $HOME",$HOME      ],"=")],"\n")
  let str_val=join([str_val,join(["       $VIM",$VIM       ],"=")],"\n")
  let str_val=join([str_val,join(["$VIMRUNTIME",$VIMRUNTIME],"=")],"\n")
  let str_val=join([str_val,join(["   $MYVIMRC",$MYVIMRC   ],"=")],"\n")
  redir => loaded_scripts
    silent execute "scriptnames"
  redir END
  let str_val=join([str_val,"Loaded scripts"],"\n\n")
  let str_val=join([str_val, loaded_scripts],"\n")
  return str_val
endfunction

" auto reload vimrc
autocmd! bufwritepost .vimrc source ~/.vim/vimrc

if has('win32')
    set grepprg=ack
"    compiler msvc
"    set makeprg=msbuild
endif

" set file type for C
autocmd BufNewFile,BufReadPost *.h,*.c set filetype=c
" set file type for C++
autocmd BufNewFile,BufReadPost *.hpp,*.hh,*.cpp,*.cc set filetype=cpp
" set file type for CMake
autocmd BufNewFile,BufReadPost CMakeLists.txt,*.cmake set filetype=cmake
autocmd FileType cmake setlocal shiftwidth=2 softtabstop=2 expandtab

" Folding by syntax
set foldmethod=syntax
set foldlevelstart=20
" Easy open/close fold : Switch map z{char} <--> z{CHAR}
" zr/mr fully open/close all.
" zo/zc fully open/close one fold
" zO open one level
for c in ['m','o','r']
  execute "nnoremap z".c "z".toupper(c)
  execute "nnoremap z".toupper(c) "z".c
endfor

""""""""""""""""""""""""""""""""""""""""""""""""
" Tab_management
""""""""""""""""""""""""""""""""""""""""""""""""
"https://stackoverflow.com/questions/102384/using-vims-tabs-like-buffers
"set switchbuf=usetab,newtab

" Switch tab
nnoremap th gT
nnoremap tl gt


""""""""""""""""""""""""""""""""""""""""""""""""
" View_(themes)
""""""""""""""""""""""""""""""""""""""""""""""""
" To know which terminal vim is runing, command :echo &term
" On windows batch, its win32, on gvim, it's builtin_gui. On linux, it's
" usually xterm or xterm-256color
" Color hightlighting for search and selection
" In PuTTY, need to set : 
"   - Window -> Apparance -> check Cursor blinks
"   - Connection -> Data -> set Terminal-type string to "xterm-256color"
"   - For shell/GitBash, check the environment variable TERM="xterm-256color"

function! ResetTheme()
    colorscheme desert

    " Always use spaces instead of tab
    set expandtab ts=4 sw=4
    " Highlight syntax
    syntax on
    " Set hybrid numbers column. To deactivate relative number :set nornu
    set number relativenumber

    set hlsearch incsearch
    set cursorline
    hi Search ctermbg=LightYellow ctermfg=DarkRed
    hi Visual ctermbg=DarkGray
    hi CursorLine cterm=NONE ctermbg=DarkBlue
    hi CursorLineNr cterm=NONE ctermbg=DarkBlue

    " Cursor shape : https://vim.fandom.com/wiki/Change_cursor_shape_in_different_modes
    let &t_SI="\e[5 q" "SI = INSERT mode        _ blink vertical bar
    let &t_SR="\e[3 q" "SR = REPLACE mode       _ blink underscore
    let &t_EI="\e[1 q" "EI = NORMAL mode (ELSE) _ blink block
endfunction

call ResetTheme()
""""""""""""""""""""""""""""""""""""""""""""""""
" Packages_and_Plugins
""""""""""""""""""""""""""""""""""""""""""""""""
"""" Native packages """""""""

" NERDTree : easy directory explorer
"    git clone https://github.com/preservim/nerdtree.git ~/.vim/pack/vendor/start/nerdtree ; vim -u NONE -c "helptags ~/.vim/pack/vendor/start/nerdtree/doc" -c q
" fast toogle NERDTree
noremap <Esc>n :NERDTreeToggle<CR>
" show line numbers in NERDTree window
let NERDTreeShowLineNumbers=1
autocmd FileType nerdtree setlocal nornu
let NERDTreeShowHidden=1

" lightline : nice statusline and tabline
"    git clone https://github.com/itchyny/lightline.vim ~/.vim/pack/plugins/start/lightline ; vim -u NONE -c "helptags ~/.vim/pack/plugins/start/lightline/doc" -c q
" Activate lightline functioinalities
set laststatus=2
" Show full path in status line
"let g:lightline = { 'component': {'filename': '%F'} }

"""" Plugins """""""""""""""""

" vim-plug : plugin manager
"    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" Then add plugin by 
"    - add to vimrc plugin session: Plug 'myplugin/path'
"    - open vimrc and run command :PlugInstall
call plug#begin('~/.vim/vim_plugin')

" nerdcommenter : usefull function commenter
Plug 'preservim/nerdcommenter'

" ack : powerfull search tool. First need to install Ack
"    - on Windows use chocolatey : choco install Ack
"    - on Linux install perl then : cpan App::Ack
Plug 'mileszs/ack.vim'

" fzf : fuzzy finder. First need to install fzf :
"    - on Windows : Download the prebuild binary from https://github.com/junegunn/fzf-bin/releases and have a look at https://github.com/jesse23/with
"    - on Linux   : git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf ; ~/.fzf/install
Plug 'junegunn/fzf', {'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" vim-cpp-modern. Better C/C++ syntax highlighting.
" Nothin to install, download files from https://github.com/bfrg/vim-cpp-modern
" then copy to ~/.vim/after/syntax
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_named_requirements_highlight = 1
let c_no_curly_error = 1

call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""
" tags
""""""""""""""""""""""""""""""""""""""""""""""""
" Use ctags to generate tag files in $HOME/.vim/tags directory
"    ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extras=+q --language-force=C++ -f /path/to/.vim/tags/boost_1_72_0.tag /path/to/DevTools/boost_1_72_0/boost

" Not using relative path in *.tag files
set notagrelative

" Load *.tag files in $HOME/.vim/tags directory
let tag_files=split(globpath('~/.vim/tags','*.tag'), '\n')
for f in tag_files
  execute "set tags+=" . f
endfor


""""""""""""""""""""""""""""""""""""""""""""""""
" Keys_mapping
""""""""""""""""""""""""""""""""""""""""""""""""

" Map alt key have a little issue on Linux as it prepend <Esc>
" to the {char}. see :h :map-alt-keys and google to see the issue
" Approach to fix it here is to map alt key from windows to prepend
" <Esc> to the char so it behave similar to linux
" From below, all alt-{char} are map to <Esc>{char}
if has('win32')
  map <A-h> <Esc>h
  map <A-j> <Esc>j
  map <A-k> <Esc>k
  map <A-l> <Esc>l
  map <A-s> <Esc>s
  map <A-d> <Esc>d
  map <A-D> <Esc>D
  map <A-n> <Esc>n
  map <A-r> <Esc>r

  imap <A-s> <Esc>s
  imap <A-r> <Esc>r

  cmap <A-h> <Esc>h
  cmap <A-l> <Esc>l
  cmap <A-s> <Esc>s
  cmap <A-d> <Esc>d
  cmap <A-D> <Esc>D
  cmap <A-n> <Esc>n
  cmap <A-r> <Esc>r
endif

" fast esc
noremap <Esc>s <Esc>
vnoremap <Esc>s <Esc>
noremap! <Esc>s <Esc>
nnoremap <Esc>s <Nop>

" fast switch to command mode
nnoremap <Esc>d :
vnoremap <Esc>d :

" fast move up/down in command line mode
cnoremap <Esc>d <Up>
cnoremap <Esc>D <Down>

" fast move up/down in normal and visual mode
nnoremap <Esc>j }
nnoremap <Esc>k {
vnoremap <Esc>j }
vnoremap <Esc>k {

" fast move left/right in normal, visual and command line mode
nnoremap E b
vnoremap E b
nnoremap <Esc>h ^
nnoremap <Esc>l $
vnoremap <Esc>h ^
vnoremap <Esc>l $
cnoremap <Esc>h <C-Left>
cnoremap <Esc>l <C-Right>

" fast register
noremap <Esc>r "
noremap! <Esc>r <C-r>

" fast windows jump
noremap <Tab> <C-w>w
tnoremap <Tab> <C-w>w
noremap <S-Tab> <C-w>W
tnoremap <S-Tab> <C-w>W
noremap <Left> <C-w>h
noremap <Right> <C-w>l
noremap <Up> <C-w>k
noremap <Down> <C-w>j

" fast reorganise split windows vertical/horizontal
nnoremap <S-Left> <C-w>H
nnoremap <S-Right> <C-w>L
nnoremap <S-Up> <C-w>K
nnoremap <S-Down> <C-w>J

" fast buffer jumps
nnoremap <Space> :bn<CR>
nnoremap <S-Space> :bp<CR>
nnoremap <C-Space> :bd<CR>

" u undo, U redo
nnoremap U <C-r>

" switch global/local map by switching uppercase/lowercase.
" Except the letter 'm' will be kept.
" ma --> mA ; 'a -->'A ; `a -->`A
" mm --> mm ; 'm -->'m ; `m -->`m (letter 'm' does not change)
for c in ['a','b','c','d','e','f','g','h','i','j','k','l','n','o','p','q','r','s','t','u','v','w','x','y','z']
  execute "nnoremap m".c "m".toupper(c)
  execute "nnoremap '".c "'".toupper(c)
  execute "nnoremap `".c "`".toupper(c)
endfor
for C in ['A','B','C','D','E','F','G','H','I','J','K','L','N','O','P','Q','R','S','T','U','V','W','X','Y','Z']
  execute "nnoremap m".C "m".tolower(C)
  execute "nnoremap '".C "'".tolower(C)
  execute "nnoremap `".C "`".tolower(C)
endfor

