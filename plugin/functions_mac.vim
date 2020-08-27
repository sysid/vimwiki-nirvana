" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0

if g:os != "Mac"
  finish
endif
if g:twvim_debug | echom "-D- Sourcing " expand('<sfile>:p') | endif

function! Xxx(link)  "{{{ xxx
  let g:paths = {"sfm1://Europe.bmw.corp/WINFS/AD-Data/Internal/01 Strategy & Steering/03 Planning & Steering": "file:/Volumes", }
  for [path, replacement] in items(g:paths)
    let prefix = split(path, ":")[0]
    echom g:paths[key]
    echom prefix
    let replace = join(['^', path], "")

    let nlink = substitute(path, replace, replacement, "")
    if g:twvim_debug
      echom link
      echom replace
      echom nlink
    endif

    let link_infos = vimwiki#base#resolve_link(nlink)
    if link_infos.filename == ''
      echomsg 'Vimwiki Error: Unable to resolve link!'
      return 0
    else
      if g:twvim_debug
        echom link_infos
      endif
      "call vimwiki#base#system_open_link(link_infos.filename)
      echom vimwiki#base#system_open_link(link_infos.filename)
      return 1
    endif

  endfor
endfunction
" }}}
