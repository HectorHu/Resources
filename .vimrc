" set runtimepath=$VIMRUNTIME

" VIM 不使用与VI兼容的模式
" set nocompatible

" 使用Vundle管理插件
" set rtp+=~/.vim/bundle/Vundle.vim
if empty(glob($HOME . '/.vim/autoload/plug.vim'))
	let path = '/.vim/autoload/plug.vim'
	if has('win32') || has('win64')
		let path = '\.vim\autoload\plug.vim'
	endif

	silent execute '!curl' '-fLo' $HOME . path '--create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin($HOME . '/.vim/bundle')

" 代码颜色主题
Plug 'tomasr/molokai'

" 代码补全工具
Plug 'Valloric/YouCompleteMe'

" 插件管理
Plug 'gmarik/Vundle.vim'

" 使代码语法高亮
Plug 'scrooloose/syntastic'

" 目录树
Plug 'scrooloose/nerdtree' | Plug 'jistr/vim-nerdtree-tabs'

" 自动格式化代码
Plug 'Chiel92/vim-autoformat'

" 对齐
Plug 'junegunn/vim-easy-align'

" tab
Plug 'majutsushi/tagbar'

Plug 'tpope/vim-eunuch'

" 快速跳转
Plug 'Lokaltog/vim-easymotion'

" 文件搜索
Plug 'ctrlpvim/ctrlp.vim'

" crtlp 辅助
Plug 'tacahiroy/ctrlp-funky'

" 符号自动补全 全单引号，双引号, 括号等等
Plug 'Raimondi/delimitMate'

" 快速注释
Plug 'scrooloose/nerdcommenter'

" 快速运行
Plug 'thinca/vim-quickrun', {'on': ['QuickRun', '<Plug>(quickrun)']}

set encoding=utf-8

call plug#end()

" 支持molokai
set t_Co=256

" 用于快速进入命令行
nnoremap ; :

" 关闭方向键
map <Left>  <Nop>
map <Right> <Nop>
map <Up>    <Nop>
map <Down>  <Nop>

" 设置行数
set number

" sudo save
cnoreabbrev W SudoWrite

" 打开文件类型检测
filetype plugin indent on

" Leader {
let mapleader = ','
" }

if has('unnamedplus')
	" When possible use + register for copy-paste
	set clipboard=unnamed,unnamedplus
else
	" On Mac and Windows, use * register for copy-paste
	set clipboard=unnamed
endif

set autoindent

set smarttab

set tabstop=8

set softtabstop=8
set noexpandtab

" PHP file check
autocmd FileType php set matchpairs-=<:>
autocmd FileType php set softtabstop=4
autocmd FileType php set sw=4
autocmd FileType php set ts=4
autocmd FileType php set sts=4


" molokai {
" Should before colorscheme
" 设置高亮
syntax on

" Should before colorscheme, too
let g:molokai_original = 1
let g:rehash256 = 1

colorscheme molokai
" }

" YouCompleteMe {
if !empty(glob('~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'))
	let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
endif

" Do not use YouCompleteMe to check C, C++ and Objective-C, do it by syntastic
let g:ycm_show_diagnostics_ui = 0
let g:ycm_complete_in_comments = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_filepath_completion_use_working_dir = 1

" Use Ctrl-o to jump back, see :help jumplist
nnoremap <silent>gd :YcmCompleter GoToDefinition<CR>
nnoremap <silent><Leader>jd :YcmCompleter GoToDeclaration<CR>
nnoremap <silent><Leader>ji :YcmCompleter GoToInclude<CR>
" }

" Syntastic
let g:syntatic_error_symbol = '×'
let g:syntatic_style_error_symbol = '×'
let g:syntatic_warning_symbol = '!'
let g:syntatic_style_warning_symbol = '!'
let g:syntatic_auto_loc_list = 2
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

function! ToggleErrors()
	let old_last_winnr = winnr('$')
	lclose
	if old_last_winnr == winnr('$')
		" Nothing was closed, open syntastic error location panel
		Errors
	endif
endfunction
nnoremap <silent><Leader>e :call ToggleErrors()<CR>
" }

" vim-autoformat {
" Execute Autoformat onsave
autocmd FileType c,go,java,json,python,lua,php,markdown,sh,vim autocmd BufWrite <buffer> :Autoformat
" Enable autoindent
let g:autoformat_autoindent = 1

" Enable auto retab
let g:autoformat_retab = 1

" Enable auto remove trailing spaces
let g:autoformat_remove_trailing_spaces = 1

" Generic C, C++, Objective-C style
" A style similar to the Linux Kernel Coding Style
" linux Kernel Coding Style: https://www.kernel.org/doc/Documentation/CodingStyle
let g:formatdef_clangformat = "'clang-format -style=\"{BasedOnStyle: LLVM, IndentWidth: 8, UseTab: Always, BreakBeforeBraces: Linux, AllowShortIfStatementsOnASingleLine: false, IndentCaseLabels: false}\"'"

" Markdown
let g:formatdef_remark_markdown = "\"remark --silent --no-color --setting 'fences: true, listItemIndent: \\\"1\\\"'\""

" }

" 按q退出vim
nnoremap <silent> q :call CloseWindow()<CR>

function! CloseWindow()
	if tabpagenr('$') > 1
		quit
		return
	endif

	let last_winnr = winnr('$')
	if last_winnr == 1 || last_winnr > 3
		quit
		return
	endif

	if last_winnr == 2 && (!exists('g:NERDTree') || !g:NERDTree.IsOpen())
		quit
		return
	endif

	if last_winnr == 3
		if !exists('g:NERDTree') || !g:NERDTree.IsOpen()
			quit
			return
		endif

		let tagbar_winnr = bufwinnr('__Tagbar__')
		if tagbar_winnr < 0
			quit
			return
		endif
	endif

	" If NERDTreeTabs is opend, only call quitall can save the session
	quitall
endfunction
" }

" Tab {
nnoremap <silent><Leader>t :execute 'tabnew' Prompt('New tab name: ', '', 'file')<CR>
nnoremap <silent>[t :tabprevious<CR>
nnoremap <silent>]t :tabnext<CR>
nnoremap <Leader>1 1gt
nnoremap <Leader>2 2gt
nnoremap <Leader>3 3gt
nnoremap <Leader>4 4gt
nnoremap <Leader>5 5gt
nnoremap <Leader>6 6gt
nnoremap <Leader>7 7gt
nnoremap <Leader>8 8gt
nnoremap <Leader>9 9gt
nnoremap <Leader>[ :tabfirst<CR>
nnoremap <Leader>] :tablast<CR>
" }

" Split {
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <silent><Leader>s :execute 'new' Prompt('New split name: ', expand('%'), 'file')<CR>
nnoremap <silent><Leader>v :execute 'vnew' Prompt('New vsplit name: ', expand('%'), 'file')<CR>

nnoremap <C-up> <C-w>+
nnoremap <C-down> <C-w>-
nnoremap <C-left> <C-w>>
nnoremap <C-right> <C-w><
" }

" Jump to start and end of line using the home row keys
noremap H ^
noremap L $

nnoremap <silent><F2> :NERDTreeTabsToggle<CR>
nnoremap <silent><F9> :QuickRun<CR>

function! Strip(input_string)
	return substitute(a:input_string, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

" Prompt({prompt_text} [, {default_value} [, {completion_type}]])
" More completion_type, please refer :h command-completion
function! Prompt(prompt_text, ...)
	call inputsave()
	let value = ''
	if a:0 == 0
		let value = input(a:prompt_text)
	elseif a:0 == 1
		let value = input(a:prompt_text, a:1)
	else
		let value = input(a:prompt_text, a:1, a:2)
	endif
	call inputrestore()
	return Strip(value)
endfunction

" NERDTree {
let g:NERDTreeAutoDeleteBuffer = 1

" Show hidden
let NERDTreeShowHidden = 1
" Ignore files type
let NERDTreeIgnore=['\.o$', '\.obj$', '\.so$', '\.dll$', '\.exe$', '\.py[co]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']

" Don't open NERDTreeTabs automatically when vim starts up
let g:nerdtree_tabs_open_on_gui_startup = 0
let g:nerdtree_tabs_open_on_console_startup = 0

" Close vim if the only window left open is a NERDTreeTabs
let g:nerdtree_tabs_autoclose = 1

" }

" vim-easy-align {
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
" }

" easymotion
let g:EasyMotion_smartcase = 1
"let g:EasyMotion_startofline = 0 " keep cursor colum when JK motion
map <Leader><leader>h <Plug>(easymotion-linebackward)
map <Leader><Leader>j <Plug>(easymotion-j)
map <Leader><Leader>k <Plug>(easymotion-k)
map <Leader><leader>l <Plug>(easymotion-lineforward)
" 重复上一次操作, 类似repeat插件, 很强大
map <Leader><leader>. <Plug>(easymotion-repeat)

" ctrlp
let g:ctrlp_map = '<leader>p'
let g:ctrlp_cmd = 'CtrlP'
map <leader>f :CtrlPMRU<CR>
let g:ctrlp_custom_ignore = {
			\ 'dir':  '\v[\/]\.(git|hg|svn|rvm)$',
			\ 'file': '\v\.(exe|so|dll|zip|tar|tar.gz|pyc)$',
			\ }
let g:ctrlp_working_path_mode=0
let g:ctrlp_match_window_bottom=1
let g:ctrlp_max_height=15
let g:ctrlp_match_window_reversed=0
let g:ctrlp_mruf_max=500
let g:ctrlp_follow_symlinks=1

" ctrlp funky
nnoremap <Leader>fu :CtrlPFunky<Cr>
" narrow the list down with a word under cursor
nnoremap <Leader>fU :execute 'CtrlPFunky ' . expand('<cword>')<Cr>
let g:ctrlp_funky_syntax_highlight = 1

let g:ctrlp_extensions = ['funky']

" nerdcommenter
" 注释的时候自动加个空格
let g:NERDSpceDelims=1

" vim-quickrun {
let g:quickrun_no_default_key_mappings = 1

map <Leader>ru <Plug>(quickrun)

augroup QuickRunRemap
	autocmd!

	autocmd FileType quickrun nnoremap <buffer><silent>q :call Quit()<CR>
augroup END
" }
