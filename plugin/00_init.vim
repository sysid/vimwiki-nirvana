" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0

" !!! Needs to be synced to all TW modules !!!

"Global variables
if !exists("g:twvim_debug")
  let g:twvim_debug = 0
endif

if !exists("g:twvim_mock")
  let g:twvim_mock = 0
endif

if g:twvim_debug | echom "-D- Sourcing " expand('<sfile>:p') | endif
let s:script_dir = fnamemodify(resolve(expand('<sfile>', ':p')), ':h')

" set the OS variable
if !exists("g:os")
    if xolox#misc#os#is_win()
        let g:os = "Windows"
        if g:twvim_debug | echom "-D- .vimrc: Windows" | endif
    elseif xolox#misc#os#is_mac()
        let g:os = "Mac"
        if g:twvim_debug | echom "-D- .vimrc: Mac" | endif
    else
        let g:os = "Linux"
        if g:twvim_debug | echom "-D- .vimrc: Linux" | endif
    endif
endif

" Check for WLS
let s:release = system('uname -r')
let s:kernel = system('uname -s')
"if stridx(s:release, "microsoft") != -1  "replace with match (stridx is case sensitive)
if s:release =~? "microsoft" && s:kernel =~? "Linux"
    let g:twvim_wsl = 1
    if g:twvim_debug | echom "-D- Running in WSL2 linux." | endif
  else
    let g:twvim_wsl = 0
endif

function! TwDebug(msg)  "{{{
  if g:twvim_debug != 1
      return
  endif

  "let time = strftime('%c')
  let file = expand('%:p:t')
  let msg = a:msg

  echom printf("-D- %s : %s", file, msg)
endfunction  "}}}

function! TwLog(msg) abort  "{{{
  echom "-M-" a:msg
endfunction  "}}}

function! TwWarn(msg) abort  "{{{
  echohl WarningMsg
  echom "-W-" a:msg
  echohl None<CR>
endfunction  "}}}

function! TwErr(msg) abort  "{{{
  "https://vi.stackexchange.com/questions/9669/print-an-error-message-without-error-detected-while-processing-function
  "execute 'normal! \<Esc>'
  echohl ErrorMsg
  echomsg "-E-" a:msg
  echohl None
endfunction  "}}}

""{{{ TwDebugTemplate, requires Vim 8.1.1310 for optional arguments with default value
""let g:log_level_map = {'DEBUG': 10, 'INFO': 20, 'WARNING': 30, 'ERROR': 40}
""let g:log_level     = "DEBUG"

"func! TwDebugTemplate(msg, level='DEBUG') abort

    "" Log to file
    ""redir >> log.vim

    "" Make sure its above the log_level
    "if g:log_level_map[a:level] < g:log_level_map[g:log_level]
        "return
    "endif

    "" _LogFormat: [TIME] LEVEL - FILE - FUNC - LINE : MSG
    "let time = strftime('%c')
    "let level = a:level
    "let file = expand('%:p:t')
    "let msg = a:msg

    "" Print the output
    "echom(printf("[%s] %s - %s : %s",
               "\ time, level, file, msg))

    ""redir END

"endfunc  "}}}
