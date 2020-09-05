# vimwiki-nirvana

Vimwiki-nirvana extends Vimwiki functionality by providing a custom handler for links. This handler implements:

1. Windows Subsystem for Linux (WSL) support for [vimwiki](https://github.com/vimwiki/vimwiki).
2. Link translation capabilities
3. Custom application configuration

This plugin requires https://github.com/xolox/vim-misc in order to establish
OS detection. It is tested on Linux, Mac and WSL.

## Installation
Install it with your favorite plugin manager, e.g. [Pathogen](https://github.com/tpope/vim-pathogen).

## General idea:
Vimwiki handles OS native paths very well. However the default behaviour 
fails on Windows Subsystem for Linux.

This plugin extends Vimwiki so that WSL works.

Additionally it allows to translate paths and to specifiy custom applications
in case the default behaviour is not what you need. 

Instead of using the default `file:/path` schema custom schemes are supported:
`custom_schema::/path`

Custom schemes call the *vimwiki-nirvana* handler which translates
the path and calls the specified application. If no application
is specified, the default launchers (`open, xdg-open`, `start`) are
used.

## Features
### WSL support:
No configuration required for HTTP links.

When *vimwiki-nirvana* detects WLS, it automatically sets `explorer.exe` as your
default program launcher for schema `http, https` and `file:/mnt/c`. To this
end *vimwiki-nirvana* changes the path `file:/mnt/<drive_letter>/a/b/` to
`<DRIVE_LETTER>:\a\b`. This allows `explorer.exe` to open the path with the registered Windows application.
For convenience Windows links like `C:\path` are allowed,
e.g. `file:C:\tmp`.

### Link Translation

A path 'prefix' will be replaced by a 'replacement'. The
resulting path will be fed to the specified executable to open the file.
If no executable is given, the defaults are used (open, xdg-open, start).

Configuration in `.vimrc`:
```vi
let g:twvim_handlers = {
      \ 'custom_schema': {'prefix': 'smb://a', 'replacement': '/Volume', 'executable': 'program for opening the file'},
\ }
```

Resulting Translation:
`custom_schema::smb://a/b/file.txt` -> `/Volume/b/file.txt`

Example:
```vi
let g:twvim_handlers = {
      \ 'home': {'prefix': 'smb://uh01500696.bmwgroup.net/home\$', 'replacement': '/Volumes/xxx'},
      \ 'win_d': {'prefix': '/mnt/d', 'replacement': 'D:', 'executable': 'explorer.exe'},
\ }
```

Caution:
- Special characters in your path prefix (e.g. $) have to be escaped.
- the executable has to be in your search PATH or you need to specify the full path

### Vim Integration

Vimwiki opens its text files by just clicking the link. It would be nice, if this
feature also applies to arbitrary text files so that they are being opened in a
new tab.

A dedicated schema makes this possible:
`vim::~/development/xxx.py`.

Use the following config in `.vimrc`:

```vi
let g:twvim_handlers = {
      \ 'vim': {'prefix': '', 'replacement': '', 'executable': 'vim'},
\ }
```

You can use path translation, i.e. specify `prefix, replacement` if needed.
