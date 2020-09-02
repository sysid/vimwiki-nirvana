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

  "handle: https://...
  if link =~? "^http[s]*://.*"
      let cmd = "!explorer.exe ".link
      call TwDebug(printf('TwWslHandler: %s', cmd))
      if !g:twvim_mock | silent execute cmd | endif
      return 1

    "handle: /mnt/c/...
    elseif link =~? "^file:/mnt/./.*"
      let drive = matchstr(link, '^file:/mnt/\zs.\ze/.*')
      call TwDebug(printf("TwWslHandler: drive: %s", drive))
      if drive == "" | return 0 | endif  "fall through to default handler

      let nlink = substitute(link, '^file:/mnt/./', drive.':/', "")

      "Gotcha:
      "opens with Word: explorer.exe 'c:\Users\Thomas\OneDrive\My Documents\vimwiki\xxx.docx'
      "opens with Explorer: explorer.exe 'c:/Users/Thomas/OneDrive/My Documents/vimwiki/xxx.docx'
      "let cmd = printf("!explorer.exe '%s'", nlink)
      let cmd = printf("!explorer.exe '%s'", substitute(nlink, "/", "\\\\", 'g'))
      call TwDebug(printf('TwWslHandler: %s', cmd))
      if !g:twvim_mock | silent execute cmd | endif
      return 1

    "handle: C:\...
    elseif link =~? "^file:.:.*"
      let drive = matchstr(link, '^file:\zs.\ze:.*')
      call TwDebug(printf("TwWslHandler: drive: %s", drive))
      if drive == "" | return 0 | endif  "fall through to default handler

      let nlink = substitute(link, '^file:', '', "")
      let cmd = printf("!explorer.exe '%s'", nlink)
      call TwDebug(printf('TwWslHandler: %s', cmd))
      if !g:twvim_mock | silent execute cmd | endif
      return 1

    else
      echom printf("-M- TwWslHandler: %s is no WEB link and no Windows-drive link, passing through.", link)
      return 0

  endif
endfunction
"let s:link = "https://learnvimscriptthehardway.stevelosh.com/"
"command! TwWslHandler :call TwWslHandler(s:link)
"}}}
