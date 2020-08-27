" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0

if g:os != "Linux"
  finish
endif
if g:twvim_debug | echom "-D- Sourcing " expand('<sfile>:p') | endif



" make sure this part is only sourced when on WSL
if g:twvim_wsl != 1
  call TwDebug("Not running in WSL, so specific functions sourced.")
  finish
endif

if exists('TwWslHandler') | finish | endif  " avoid test error

function! TwWslHandler(link)  "{{{ use not default handler like sdg-open, but specific one
  let link = a:link

  "if link =~? "^http[s]\?:\/\/.*"
  " TODO: better pattern
  if link =~? "^http.*:.*"
      "let cmd = "!explorer.exe '" . substitute(nlink, "/", "\\\\", 'g') ."'"
      let cmd = "!explorer.exe ".link
      call TwDebug(cmd)
      silent execute cmd
      return 1
    else
      echom "-M- TwWslHandler: this is not a WEB link, passing through."
      return 0
  endif
endfunction
"let s:link = "https://learnvimscriptthehardway.stevelosh.com/"
"command! TwWslHandler :call TwWslHandler(s:link)
"}}}
