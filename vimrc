""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Author Chi Thanh Nguyen
"        chithanhnguyen.math@gmail.com
"
"        git@github.com:ctnguyen/.vim.git
"
" TOC
"   - Build
"   - General
"   - Tab_management
"   - View_(themes)
"   - Compilation_in_vim
"   - Packages_and_Plugins
"   - Keys_mapping
"
" TODO :
"   - Look at various vimrc on github, net to improve
"   - Test first in command mode before puting in vimrc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" On Windows, it is important to set encoding utf-8 at the top of the vimrc file.
" Otherwise it will break mapping alt-key
if has('win32')
    set encoding=utf-8
endif

""""""""""""""""""""""""""""""""""""""""""""""""
" Build vim from source
""""""""""""""""""""""""""""""""""""""""""""""""
" Presetup Ubuntu
"     sudo apt install -y libxt-dev python3-pip python3-dev libpython3-dev libncurses-dev curl
"
" Setup python
"     python -m pip install pytest mkdocs pymdown-extensions plantuml_markdown
" Clone the source
"     git clone -b v9.0.1670 https://github.com/vim/vim.git ; cd vim
" On Ubuntu
"     ./configure --with-features=huge --enable-cscope --enable-multibyte --enable-python3interp --with-python3-config-dir=$(python3-config --configdir) --enable-fail-if-missing --prefix=/abs/path/to/devtool/vim-9.0
"     make -j8 install
"
" On Windows
"     TODO

""""""""""""""""""""""""""""""""""""""""""""""""
" General
""""""""""""""""""""""""""""""""""""""""""""""""
"
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

" https://vim.fandom.com/wiki/Accessing_the_system_clipboard
" set clipboard=unnamed

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
"set foldlevelstart=20 "TODO this disable remembering fold level when buffer
"switch

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
" Compilation_in_vim
""""""""""""""""""""""""""""""""""""""""""""""""
" Vim use combination of makeprg (command) and errorformat (parser)
" to populate errors from a command to quickfix. It already natively
" has some default compiler. See in $VIM_INSTALL/compiler

" Set default global compiler on Windows.
if has('win32')
    compiler! msbuild
endif

" It is possible to write a compiler plugin, i.e
" Write a plugin that execute boost unit test and parse the error so quickfix
" can jump directly to the error line. Same thing for pytest

""""""""""""""""""""""""""""""""""""""""""""""""
" Packages_and_Plugins
""""""""""""""""""""""""""""""""""""""""""""""""
"""" Native packages """""""""

" NERDTree : easy directory explorer
"    git clone https://github.com/preservim/nerdtree.git ~/.vim/pack/vendor/start/nerdtree ; vim -u NONE -c "helptags ~/.vim/pack/vendor/start/nerdtree/doc" -c q
" fast toogle NERDTree
noremap <M-n> :NERDTreeToggle<CR>
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

" vim-go : IDE like development for golang
"    git clone https://github.com/fatih/vim-go.git ~/.vim/pack/plugins/start/vim-go ; vim -u NONE -c "helptags ~/.vim/pack/plugins/start/vim-go/doc" -c q
" Disable vim-go auto modifying text
let g:go_fmt_autosave = 0
let g:go_mod_fmt_autosave = 0
let g:go_fmt_command = "goimports"
" Setup the widgets locations
let g:go_debug_windows = {
        \ 'vars':       'rightbelow 30vnew',
        \ 'stack':      'rightbelow 20new',
        \ 'out':        'botright 5new',
    \ }

" vimspector
"    git clone https://github.com/puremourning/vimspector ~/.vim/pack/vimspector/opt/vimspector
"    cd ~/.vim/pack/vimspector/opt/vimspector
"    python install_gadget.py --enable-python --force-enable-node
" Then it will need a manual action : create a file .vimspector.json in the
" root directory of the python project to let vimspector regconize. Have a
" look on the website how to create that  file, or copy example from
"    ~/.vim/pack/vimspector/opt/vimspector/support/test/python
" Similar approach can work with nodejs, truffle as well
let g:vimspector_enable_mappings = 'VISUAL_STUDIO'
packadd! vimspector

" vim-cpp-modern. Better C/C++ syntax highlighting.
"     git clone --depth=1 https://github.com/bfrg/vim-cpp-modern ~/.vim/pack/git-plugins/start ; rm ~/.vim/pack/git-plugins/start/README.md ; rm -fR ~/.vim/pack/git-plugins/start/.git
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_named_requirements_highlight = 1
let c_no_curly_error = 1

" vim-javascript : tools for javascript
"    git clone https://github.com/pangloss/vim-javascript.git ~/.vim/pack/vim-javascript/start/vim-javascript
let g:javascript_plugin_jsdoc = 1
augroup javascript_folding
    au!
    au FileType javascript setlocal foldmethod=syntax
augroup END

"""" Plugins using vim-plug """""""""""""""""

" vim-plug : plugin manager
"    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" Then add plugin by 
"    - add to vimrc plugin session: Plug 'myplugin/path'
"    - open vimrc and run command :PlugInstall
call plug#begin('~/.vim/vim_plugin')

" nerdcommenter : usefull function commenter
Plug 'preservim/nerdcommenter'

" vim-easy-align
"     https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" ack : powerfull search tool. First need to install Ack
"    - on Windows use chocolatey : choco install Ack
"    - on Linux install perl then : cpan App::Ack
"Plug 'mileszs/ack.vim'

" fzf : fuzzy finder. First need to install fzf :
"    - on Windows : Download the prebuild binary from https://github.com/junegunn/fzf-bin/releases and have a look at https://github.com/jesse23/with
"    - on Linux   : git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf ; ~/.fzf/install
"Plug 'junegunn/fzf', {'do': { -> fzf#install() } }
"Plug 'junegunn/fzf.vim'

" Solidity highlighting
" https://github.com/TovarishFin/vim-solidity
let g:polyglot_disabled = ['solidity']
Plug 'TovarishFin/vim-solidity'

call plug#end()
"""""""""""""""""

"""" Plugins using Vundle """""""""""""""""
" https://github.com/VundleVim/Vundle.vim#about
"    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
set nocompatible
filetype off
set shellslash
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin('~/vimfiles/bundle')

Plugin 'VundleVim/Vundle.vim'

"if has('win32')
"    set encoding=utf-8
"endif
"Plugin 'ycm-core/YouCompleteMe'

call vundle#end()
filetype plugin indent on



""""""""""""""""""""""""""""""""""""""""""""""""
" tags
""""""""""""""""""""""""""""""""""""""""""""""""
" Use ctags to generate tag files in $HOME/.vim/tags directory
"    ctags -R --sort=yes --c++-kinds=+pf --fields=+iaS --extra=+q --language-force=C++ -f /path/to/.vim/tags/boost_1_72_0.tag /path/to/DevTools/boost_1_72_0/boost

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
"
" The following make the map for alt key work on Linux
" See : https://vi.stackexchange.com/questions/2350/how-to-map-alt-key
if !has('win32')
  execute "set <M-h>=\eh"
  execute "set <M-j>=\ej"
  execute "set <M-k>=\ek"
  execute "set <M-l>=\el"
  execute "set <M-s>=\es"
  execute "set <M-d>=\ed"
  execute "set <M-D>=\eD"
  execute "set <M-n>=\en"
  execute "set <M-r>=\er"
endif

" fast esc
noremap <M-s> <Esc>
xnoremap <M-s> <Esc>
noremap! <M-s> <Esc>
nnoremap <M-s> <Nop>

" fast cancel highlight search and highlight visual
nnoremap <Space> :nohls<CR>
xnoremap <Space> <Esc>:nohls<CR>

" fast switch to command mode
nnoremap <M-d> :
xnoremap <M-d> :
tnoremap <M-d> <C-w>:

" fast move up/down in command line mode
cnoremap <M-d> <Up>
cnoremap <M-D> <Down>

" fast move up/down in normal and visual mode
nnoremap <M-j> }
nnoremap <M-k> {
vnoremap <M-j> }
vnoremap <M-k> {

" fast move left/right in normal, visual and command line mode
nnoremap <M-h> ^
nnoremap <M-l> $
vnoremap <M-h> ^
vnoremap <M-l> $
cnoremap <M-h> <C-Left>
cnoremap <M-l> <C-Right>

" fast register
noremap <M-r> "
noremap! <M-r> <C-r>

" fast reorganise split windows vertical/horizontal
nnoremap <S-Left> <C-w>H
nnoremap <S-Right> <C-w>L
nnoremap <S-Up> <C-w>K
nnoremap <S-Down> <C-w>J
tnoremap <S-Left> <C-w>H
tnoremap <S-Right> <C-w>L
tnoremap <S-Up> <C-w>K
tnoremap <S-Down> <C-w>J

" fast windows resize
nnoremap <Left> :vertical resize -5<CR>
nnoremap <Right> :vertical resize +5<CR>
nnoremap <Up> :resize +2<CR>
nnoremap <Down> :resize -2<CR>

" fast window/buffer jumps using <Tab>
"   - More than one windows : switch window
"   - Only one window       : switch buffer
"   - b<Tab> always switch buffer
noremap <expr> <Tab> winnr('$')>1 ? '<C-w>w' : ':bnext<CR>'
noremap <expr> <S-Tab> winnr('$')>1 ? '<C-w>W' : ':bprevious<CR>'
noremap <expr> b<Tab> ':bnext<CR>'
noremap <expr> b<S-Tab> ':bprevious<CR>'

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

