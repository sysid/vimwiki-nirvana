#!/usr/bin/env bash
#vim '+Vader!*' && echo Success || echo Failure' && echo Success || echo Failure

if [ -z "$1" ]; then
    echo "-E- no testfiles given."
    echo "runall: $0 '*'"
    exit 1
fi

vim -Nu <(cat << EOF
filetype off
set rtp+=~/.vim/plugged/vader.vim
set rtp+=~/.vim/plugged/vim-markdown
set rtp+=~/.vim/plugged/vim-markdown/after
set rtp+=~/.vim/plugged/vim-misc
set rtp+=~/.vim/plugged/tw-vim
set rtp+=~/.vim/plugged/vimwiki-nirvana
filetype plugin indent on
syntax enable

let g:twvim_wsl = 1
let g:twvim_debug = 0
let g:os = 'Linux'
if g:twvim_debug | echom "-D- Debugging is activated." | endif
EOF) "+Vader! $1" && echo Success || echo Failure
