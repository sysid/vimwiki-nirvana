" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0
if g:twvim_debug | echom "-D- Sourcing " expand('<sfile>:p') | endif
let s:script_dir = fnamemodify(resolve(expand('<sfile>', ':p')), ':h')

" set the OS variable
if !exists("g:os")
    if xolox#misc#os#is_win()
        let g:os = "Windows"
        if g:twvim_debug | echom "-M- .vimrc: Windows" | endif
    elseif xolox#misc#os#is_mac()
        let g:os = "Mac"
        if g:twvim_debug | echom "-M- .vimrc: Mac" | endif
    else
        let g:os = "Linux"
        if g:twvim_debug | echom "-M- .vimrc: Linux" | endif
    endif
endif

" Check for WLS 
let s:release = system('uname -r')
"if stridx(s:release, "microsoft") != -1  "replace with match (stridx is case sensitive)
if s:release =~? "microsoft"
    let g:twvim_wsl = 1
    if g:twvim_debug | echom "-D- Running in WSL2 linux." | endif
endif


