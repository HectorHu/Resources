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

" 
Plugin 'scrooloose/syntastic'

call vundle#end()

" 用于快速进入命令行
nnoremap ; :

" Leader {
let mapleader = ','
" }

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
