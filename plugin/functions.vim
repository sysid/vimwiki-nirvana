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
"let file = '/mnt/d/Users/Thomas/OneDrive/My Documents/xxx.docx'
"let file = '/mnt/d/Users/Thomas/OneDrive/My Documents/'
"let file = "/Volumes/AD-Data/Internal/01 Strategy & Steering/03 Planning & Steering/06 Digitalisation/10_Projekte/PublicCharging/"
"command! TwIsLinkValid :echo TwIsLinkValid(file)
"}}}

function! VimwikiLinkHandler(link)  "{{{ Use Vim to open links with special schemes
  "https://stackoverflow.com/questions/31080937/vimwiki-local-file-link-handling
  "https://github.com/vimwiki/issues/71

  call TwDebug("VimwikiHandler: running on ".hostname())

  let link = a:link
  "let link_type = 0  " 0:none, 1:unix, 2:windows

  " if WSL standard html links requires windows explorer
  if g:twvim_wsl
    call TwLog("VimwikiLinkHandler: Calling WSL Handler.")
    call TwWslHandler(link)
  endif

  "if link =~? "^xxx::.*"
    "source handler.vim
    "call TwLog("VimwikiLinkHandler: Calling xxx Handler.")
    "call TwHandler(link)
  "endif
  return TwHandler(link)

endfunction

" highlight the prefixes (containedin=cComment,vimLineComment)
autocmd Syntax * syntax keyword twLink win qnr sfm1 coco containedin=ALL
highlight link twLink Keyword
" }}}

function! TwFiles()  " {{{
  " https://stackoverflow.com/questions/30171512/how-to-set-the-root-of-git-repository-to-vi-vim-find-path
  " looks for project root and start fzf search from there
  let g:gitdir=substitute(system("git rev-parse --show-toplevel 2>&1 | grep -v fatal:"),'\n','','g')
  if  g:gitdir != '' && isdirectory(g:gitdir) && index(split(&path, ","),g:gitdir) < 0
    "exe "set path+=".g:gitdir."/*"
    echo g:gitdir
    call fzf#vim#files(g:gitdir, 0)
  else
    echo "searchin working dir"
    call fzf#vim#files(".")
  endif
endfunction
command! TwFiles :call TwFiles()
" }}}

function! PrintGivenRange() range  " {{{
    echo "firstline ".a:firstline." lastline ".a:lastline
        " Do some more things
    endfunction
command! -range TwPassRange <line1>,<line2>call PrintGivenRange()
" }}}

function! MergeTab()  "{{{ Merge Tab into Split
    let bufnums = tabpagebuflist()
    hide tabclose
    topleft vsplit
    for n in bufnums
        execute 'sbuffer ' . n
        wincmd _
    endfor
    wincmd t
    quit
    wincmd =
endfunction
command! TwMergeTab call MergeTab()  "}}}

fun! CleanExtraSpaces()  "{{{ Delete trailing white space on save, useful for some filetypes ;)
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun
command! TwCleanWhiteSpaces call CleanExtraSpaces()

if has("autocmd")
    autocmd BufWritePre .vimrc,*.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
endif  "}}}

function! TabMessage(cmd)  "{{{ Function to capture command line output
  "example: :TabMessage set runtime?
  redir => message
  silent execute a:cmd
  redir END
  if empty(message)
    echoerr "no output"
  else
    " use "new" instead of "tabnew" below if you prefer split windows instead of tabs
     tabnew
     setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
     silent put=message
  endif
endfunction
command! -nargs=+ -complete=command TwTabMessage call TabMessage(<q-args>)  "}}}

function! TwTags()  "{{{ Function to recreate vimwiki tags
  exe 'normal! ggVGd\<esc>'
  call vimwiki#tags#update_tags(1, '<bang>')
  call vimwiki#tags#generate_tags(1)
  echo "-M- Vimwiki Tags rebuilt."
endfunction
command! TwTags call TwTags()  "}}}

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

func TwDebug(msg, level='DEBUG') abort  "{{{
    if g:twvim_debug != 1
        return
    endif

    "let time = strftime('%c')
    let file = expand('%:p:t')
    let msg = a:msg

    echom(printf("-D- %s : %s", file, msg))
endfunc  "}}}

"{{{ TwDebugTemplate
"let g:log_level_map = {'DEBUG': 10, 'INFO': 20, 'WARNING': 30, 'ERROR': 40}
"let g:log_level     = "DEBUG"

func TwDebugTemplate(msg, level='DEBUG') abort

    " Log to file
    "redir >> log.vim

    " Make sure its above the log_level
    if g:log_level_map[a:level] < g:log_level_map[g:log_level]
        return
    endif

    " _LogFormat: [TIME] LEVEL - FILE - FUNC - LINE : MSG
    let time = strftime('%c')
    let level = a:level
    let file = expand('%:p:t')
    let msg = a:msg

    " Print the output
    echom(printf("[%s] %s - %s : %s",
               \ time, level, file, msg))

    "redir END

endfunc  "}}}
