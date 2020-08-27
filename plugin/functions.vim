" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0
if g:twvim_debug | echom "-D- Sourcing " expand('<sfile>:p') | endif
let s:script_dir = fnamemodify(resolve(expand('<sfile>', ':p')), ':h')

function! TwIsLinkValid(FileName)  "{{{ This function returns true if the FileName is a valid vimwicki link
  "return !empty(glob(a:FileName))  " test existence, not readability
  call TwDebug(printf("TwIsLinkValid: link: %s", a:FileName))
  if isdirectory(a:FileName)
      return 1
  elseif filereadable(a:FileName)
      return 1
  else
      "echom '-E- invalid link:' Filename
      return 0
endfunction
"let file = '/Volumes/AD-Data/Internal/01 Strategy & Steering/03 Planning & Steering/06 Digitalisation/10_Projekte/PublicCharging/'
"command! TwIsLinkValid :echo TwIsLinkValid(file)
"}}}

function! VimwikiLinkHandler(link)  "{{{ Use Vim to open links with special schemes
  "https://stackoverflow.com/questions/31080937/vimwiki-local-file-link-handling
  "https://github.com/vimwiki/issues/71

  call TwDebug("VimwikiHandler: running on ".hostname())
  let link = a:link

  " must run before default handler to have proper priority
  if TwHandler(link)
    return 1
  endif

  " if WSL standard html links require windows explorer
  if g:twvim_wsl
    call TwLog("VimwikiLinkHandler: Calling WSL Handler.")
    return TwWslHandler(link)
  endif

  call TwDebug("VimwikiLinkHandler: Passing through to default handler")
  return 0
endfunction

" highlight the prefixes (containedin=cComment,vimLineComment)
"TODO autocmd Syntax * syntax keyword twLink win qnr sfm1 coco containedin=ALL
"highlight link twLink Keyword
" }}}
