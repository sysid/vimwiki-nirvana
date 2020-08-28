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
  if link =~? "^http[s]*://.*"
      let cmd = "!explorer.exe ".link
      call TwDebug(printf('TwWslHandler: %s', cmd))
      "silent execute cmd
      return 1
    elseif link =~? "^file:/mnt/./.*"
      let drive = matchstr(link, '^file:/mnt/\zs.\ze/.*')
      call TwDebug(printf("TwWslHandler: drive: %s", drive))
      if drive == "" | return 0 | endif  "fall through to default handler

      let nlink = substitute(link, '^file:/mnt/./', drive.':/', "")
      "let cmd = "!explorer.exe '" . substitute(nlink, "/", "\\\\", 'g') ."'"
      let cmd = printf("!explorer.exe '%s'", nlink)
      call TwDebug(printf('TwWslHandler: %s', cmd))
      return 1
    elseif link =~? "^file:.:.*"
      let drive = matchstr(link, '^file:\zs.\ze:.*')
      call TwDebug(printf("TwWslHandler: drive: %s", drive))
      if drive == "" | return 0 | endif  "fall through to default handler

      let nlink = substitute(link, '^file:', '', "")
      let cmd = printf("!explorer.exe '%s'", nlink)
      call TwDebug(printf('TwWslHandler: %s', cmd))
      return 1
    else
      echom printf("-M- TwWslHandler: %s is no WEB link and no Windows-drive link, passing through.", link)
      return 0
  endif
endfunction
"let s:link = "https://learnvimscriptthehardway.stevelosh.com/"
"command! TwWslHandler :call TwWslHandler(s:link)
"}}}
