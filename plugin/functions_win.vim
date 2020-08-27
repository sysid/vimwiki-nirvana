" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0
if g:os != "Windows"
  finish
endif
if g:twvim_debug | echom "-D- Sourcing " expand('<sfile>:p') | endif
