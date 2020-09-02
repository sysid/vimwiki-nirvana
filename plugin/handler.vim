" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0

if g:twvim_debug | echom "-D- Sourcing " expand('<sfile>:p') | endif

function! TwHandler(link)  "{{{ do not use default handler like sdg-open, but specific one
  " define one schema per replacment
  " if replacement cannot be done, original link is returned and tested for existence
  " return: 2 (if invalid link: no fallback), 0 (fallback to default handler, 1 (success)

  let link = a:link

  let schema= TwExtractSchema(link)
  if schema == "" | return 0 | endif

  "if link =~? "^".schema."::.*"
    "call TwLog("VimwikiLinkHandler: Calling xxx Handler.")
  "endif

  let prefix = g:twvim_handlers[schema]['prefix']
  let replacement = g:twvim_handlers[schema]['replacement']
  let executable = ""

  if has_key(g:twvim_handlers[schema], 'executable')
    let executable = g:twvim_handlers[schema]['executable']
  endif

  call TwDebug(printf("TwHandler: schema: %s, prefix: %s, %s, exec: %s", schema, prefix, replacement, executable))
  call TwDebug(printf("TwHandler: link: %s", link))

  let toreplace = schema.'::'.prefix
  call TwDebug(printf("TwHandler: toreplace: %s", toreplace))

  " TODO: in case no replacment possible: better user feedback
  let nlink = fnamemodify(expand(substitute(link, toreplace, replacement, "")), ':p')
  call TwDebug(printf("TwHandler: nlink: %s", nlink))

  if !TwIsLinkValid(nlink)
    call TwWarn(printf("TwHandler: Invalid or non-existing link: %s", nlink))
    return 2
  endif

  if executable != ""
    if executable =~? 'vim'
      execute "tabnew" nlink
      return 1
    endif
      "let cmd = "!explorer.exe '" . substitute(nlink, "/", "\\\\", 'g') ."'"
      let cmd = printf("!%s %s", executable, nlink)
      call TwDebug(printf("TwHandler: %s", cmd))
      call TwWarn(printf("TwHandler: Must activate action."))
      "silent execute cmd
      return 1
    else
      call TwDebug(printf("TwHandler: calling default open|xdg-open|start: %s", nlink))
      let link_infos = vimwiki#base#resolve_link(nlink)  " no error when remote fs unmounted, resolves relative links
      if link_infos.filename == ''
        call TwWarn("TwHandler: Unable to resolve link ".nlink)
        return 0
      else
        call TwDebug(printf("TwHandler: link_infos: %s", link_infos))
        call vimwiki#base#system_open_link(link_infos.filename)
        return 1
      endif
  endif
endfunction

"let s:link = "xxxxxx::smb://xxx/aaa/learnvimscriptthehardway.stevelosh.com/"
"command! TwHandler :call TwHandler(s:link)
"let s:link = "yyy::smb://yyy/tevelosh.com/"
"command! TwHandler :call TwHandler(s:link)
"}}}

function! TwExtractSchema(link) abort
  let link = a:link
  " echo matchstr('aebsd::asdfasdf:asdf/asdf', '\zs.*\ze::.*')
  let schema = matchstr(link, '\zs.*\ze::.*')
  call TwDebug(printf("TwExtractSchema: schema: %s", schema))
  if schema == "" | return "" | endif
  if index(keys(g:twvim_handlers), schema) == -1
    call TwWarn(printf("TwHandler: Undefined schema '%s', must b in [%s]", schema, join(keys(g:twvim_handlers), ',')))
    return ""
  endif
  return schema
endfunc
