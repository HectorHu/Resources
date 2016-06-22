set runtimepath=$VIMRUNTIME

" VIM 不使用与VI兼容的模式
set nocompatible

" 使用Vundle管理插件
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()

" 代码颜色主题
Plugin 'tomastr/molokai'

" 代码补全工具
Plugin 'Valloric/YouCompleteMe'

" 插件管理
Plugin 'gmarik/Vundle.vim'

" 使代码语法高亮
Plugin 'scrooloose/syntastic'

" 目录树
Plugin 'scrooloose/nerdtree' | Plugin 'jistr/vim-nerdtree-tabs'

" 自动格式化代码
Plugin 'Chiel92/vim-autoformat'

" 对齐
Plugin 'junegunn/vim-easy-align'

" tab
Plugin 'majutsushi/tagbar'

Plugin 'tpope/vim-eunuch'

call vundle#end()

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

" PHP file check
autocmd FileType php set matchpairs-=<:>

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
autocmd FileType c,go,java,javascript,json,python,lua,php,markdown,sh,vim autocmd BufWrite <buffer> :Autoformat
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
nnoremap <silent><S-h> :tabprevious<CR>
nnoremap <silent><S-l> :tabnext<CR>
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

nnoremap <silent><F2> :NERDTreeTabsToggle<CR>

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
