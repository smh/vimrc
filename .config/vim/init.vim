" Attempt to support XDG_CONFIG_HOME
" Environment
"set directory=$XDG_CACHE_HOME/vim,~/,/tmp
"set backupdir=$XDG_CACHE_HOME/vim,~/,/tmp
"set viminfo+=n$XDG_CACHE_HOME/vim/viminfo
"set runtimepath=$XDG_CONFIG_HOME/vim,$XDG_CONFIG_HOME/vim/after,$VIM,$VIMRUNTIME
"let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc"

set nocompatible
"filetype off

" Setup vim-plug ----------------------------{{{
call plug#begin('~/.config/vim/plugged')

Plug 'benekastah/neomake'
Plug 'bling/vim-airline'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-markdown'
if !has('nvim')
  Plug 'tpope/vim-sensible'
endif
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'scrooloose/nerdcommenter'
"Plug 'scrooloose/syntastic'
"Plug 'majutsushi/tagbar'
Plug 'jeetsukumaran/vim-buffergator'
"Plug 'altercation/vim-colors-solarized'
Plug 'chriskempson/base16-vim'
Plug 'vimwiki'
"Plug 'skammer/vim-css-color' " causing slow loading of html files
"Plug 'basepi/vim-conque'
"Plug 'skwp/vim-ruby-conque'
"Plug 'godlygeek/tabular'
Plug 'ledger/vim-ledger'
Plug 'othree/html5.vim'
Plug 'pangloss/vim-javascript'
Plug 'elzr/vim-json'
au BufNewFile,BufRead *.json setf json
Plug 'editorconfig/editorconfig'
Plug 'airblade/vim-gitgutter'

Plug 'gorodinskiy/vim-coloresque'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Clojure stuff
"Plug 'guns/vim-clojure-static'
"Plug 'kien/rainbow_parentheses.vim'
"Plug 'tpope/vim-fireplace'
"Plug 'tpope/vim-leiningen'
"Plug 'vim-scripts/paredit.vim'

Plug 'christoomey/vim-tmux-navigator'

Plug 'wakatime/vim-wakatime'

if has('nvim')
  Plug 'Shougo/deoplete.nvim'
endif

Plug 'ternjs/tern_for_vim', { 'do': 'npm install' }
Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
Plug 'SirVer/ultisnips'

Plug 'jaawerth/nrun.vim' " which and exec functions targeted at node projects

Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'

call plug#end()
" }}}
"
" Settings -------------------------{{{
"filetype plugin indent on

"syntax on

set nocompatible
set list
set relativenumber number
set autowrite
set incsearch
set smartcase
set expandtab
set tabstop=2
set shiftwidth=2
set cursorline
set laststatus=2
set lazyredraw
set backspace=2
set hlsearch
if has('nvim')
  set inccommand=nosplit
endif
set encoding=utf8

" Windows *********************************************************************
set equalalways " Multiple windows, when created, are equal in size
set splitbelow splitright

" Show tabs and trailing spaces
if (&termencoding ==# 'utf-8' || &encoding ==# 'utf-8') && version >= 700
  "set listchars=tab:›,trail:·
  "let &listchars = "tab:\u21e5\u00b7,trail:\u2423,extends:\u21c9,precedes:\u21c7,nbsp:\u26ad"
  let &listchars = "tab:\u203a\u00b7,trail:\u2423,extends:\u21c9,precedes:\u21c7,nbsp:\u26ad"
  let &fillchars = "vert:\u259a,fold:\u00b7"
else
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<
endif

let mapleader = " "

map <leader>n :NERDTreeFocus<CR>
map <leader>v :vsplit<CR>
map <leader>h :split<CR>
"map <leader>m :TagbarToggle<CR>

map <leader>gs :Gstatus<CR>

map <a-/> <Plug>NERDCommenterToggle
map <c-/> <Plug>NERDCommenterToggle

map <leader>f :Files<cr>
"}}}
"
" Color ---------------------------------{{{
"set background=dark
"let g:solarized_termcolors=16
"let g:solarized_visibility="high"
"let g:solarized_contrast="high"
"color solarized

"set background=dark
"let base16colorspace=256
"colorscheme base16-default-dark


" load base16 colorscheme
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

"}}}

set undofile
set undodir="$HOME/.config/.vim_undo_files"

" Remember cursor position between vim sessions
autocmd BufReadPost *
            \ if line("'\"") > 0 && line ("'\"") <= line("$") |
            \   exe "normal! g'\"" |
            \ endif
            " center buffer around cursor when opening files
autocmd BufRead * normal zz

set foldmethod=syntax
"set foldlevelstart=1
autocmd Syntax javascript,json,c,java,ruby,python,clojure normal zR

let javaScript_fold=1         " JavaScript
let perl_fold=1               " Perl
let php_folding=1             " PHP
let r_syntax_folding=1        " R
let ruby_fold=1               " Ruby
let sh_fold_enabled=1         " sh
let vimsyn_folding='af'       " Vim script
let xml_syntax_folding=1      " XML

"let g:syntastic_mode_map = { 'mode': 'active',
"                           \ 'active_filetypes': ['foo', 'bar'],
"                           \ 'passive_filetypes': ['java'] }

"au FileType javascript call JavaScriptFold()

let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute "]
"let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]

let g:ledger_fillstring = '·'

let g:airline_powerline_fonts = 1

function! DoPrettyXML()
  " save the filetype so we can restore it later
  let l:origft = &ft
  set ft=
  " delete the xml header if it exists. This will
  " permit us to surround the document with fake tags
  " without creating invalid xml.
  1s/<?xml .*?>//e
  " insert fake tags around the entire document.
  " This will permit us to pretty-format excerpts of
  " XML that may contain multiple top-level elements.
  0put ='<PrettyXML>'
  $put ='</PrettyXML>'
  silent %!xmllint --format -
  " xmllint will insert an <?xml?> header. it's easy enough to delete
  " if you don't want it.
  " delete the fake tags
  2d
  $d
  " restore the 'normal' indentation, which is one extra level
  " too deep due to the extra tags we wrapped around the document.
  silent %<
  " back to home
  1
  " restore the filetype
  exe "set ft=" . l:origft
endfunction
command! PrettyXML call DoPrettyXML()

" deoplete config
let g:deoplete#enable_at_startup = 1
" disable autocomplete
"let g:deoplete#disable_auto_complete = 1
if has("gui_running")
    inoremap <silent><expr><C-Space> deoplete#mappings#manual_complete()
else
    inoremap <silent><expr><C-@> deoplete#mappings#manual_complete()
endif

" UltiSnips config
inoremap <silent><expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" omnifuncs
augroup omnifuncs
  autocmd!
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
augroup end

" tern
if exists('g:plugs["tern_for_vim"]')
  let g:tern_map_keys=1
  let g:tern_show_argument_hints = 'on_hold'
  let g:tern_show_signature_in_pum = 1
  let g:tern#command = ["tern"]
  let g:tern#arguments = ["--persistent"]

  autocmd FileType javascript setlocal omnifunc=tern#Complete


endif

" update navigation keys
"for dir in ["h", "j", "k", "l"]
  "execute "nnoremap" "<silent>" "<c-" . dir . ">" "<c-w>" . dir
  "execute "vnoremap" "<silent>" "<c-" . dir . ">" "<c-\><c-n><c-w>" . dir . ">"
  "execute "inoremap" "<silent>" "<c-" . dir . ">" "<c-\><c-n><c-w>" . dir . ">"
  "execute "cnoremap" "<silent>" "<c-" . dir . ">" "<c-\><c-n><c-w>" . dir . ">"
  "if has('nvim')
    "execute "tnoremap" "<c-" . dir . ">" "<c-\><c-n><c-w>" . dir . ">"
  "endif
"endfor
"if has('nvim')
  "au WinEnter *pid:* call feedkeys('i')
"endif
nnoremap <silent> <a-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <a-j> :TmuxNavigateDown<cr>
nnoremap <silent> <a-k> :TmuxNavigateUp<cr>
nnoremap <silent> <a-l> :TmuxNavigateRight<cr>
nnoremap <silent> <a-\\> :TmuxNavigatePrevious<cr>
vnoremap <a-h> <c-\><c-n>:TmuxNavigateLeft<cr>
vnoremap <a-j> <c-\><c-n>:TmuxNavigateDown<cr>
vnoremap <a-k> <c-\><c-n>:TmuxNavigateUp<cr>
vnoremap <a-l> <c-\><c-n>:TmuxNavigateRight<cr>
vnoremap <a-\\> <c-\><c-n>:TmuxNavigatePrevious<cr>
inoremap <a-h> <c-\><c-n>:TmuxNavigateLeft<cr>
inoremap <a-j> <c-\><c-n>:TmuxNavigateUp<cr>
inoremap <a-k> <c-\><c-n>:TmuxNavigateDown<cr>
inoremap <a-l> <c-\><c-n>:TmuxNavigateRight<cr>
inoremap <a-\\> <c-\><c-n>:TmuxNavigatePrevious<cr>
cnoremap <a-h> <c-\><c-n>:TmuxNavigateLeft<cr>
cnoremap <a-j> <c-\><c-n>:TmuxNavigateUp<cr>
cnoremap <a-k> <c-\><c-n>:TmuxNavigateDown<cr>
cnoremap <a-l> <c-\><c-n>:TmuxNavigateRight<cr>
cnoremap <a-\\> <c-\><c-n>:TmuxNavigatePrevious<cr>
if has('nvim')
  tnoremap <a-j> <c-\><c-n>:TmuxNavigateLeft<cr>
  tnoremap <a-k> <c-\><c-n>:TmuxNavigateUp<cr>
  tnoremap <a-h> <c-\><c-n>:TmuxNavigateDown<cr>
  tnoremap <a-l> <c-\><c-n>:TmuxNavigateRight<cr>
  au WinEnter *pid:* call feedkeys('i')
endif

"nnoremap <a-j> <c-w>j
"nnoremap <a-k> <c-w>k
"nnoremap <a-h> <c-w>h
"nnoremap <a-l> <c-w>l
"vnoremap <a-j> <c-\><c-n><c-w>j
"vnoremap <a-k> <c-\><c-n><c-w>k
"vnoremap <a-h> <c-\><c-n><c-w>h
"vnoremap <a-l> <c-\><c-n><c-w>l
"inoremap <a-j> <c-\><c-n><c-w>j
"inoremap <a-k> <c-\><c-n><c-w>k
"inoremap <a-h> <c-\><c-n><c-w>h
"inoremap <a-l> <c-\><c-n><c-w>l
"cnoremap <a-j> <c-\><c-n><c-w>j
"cnoremap <a-k> <c-\><c-n><c-w>k
"cnoremap <a-h> <c-\><c-n><c-w>h
"cnoremap <a-l> <c-\><c-n><c-w>l
"if has('nvim')
  "tnoremap <a-j> <c-\><c-n><c-w>j
  "tnoremap <a-k> <c-\><c-n><c-w>k
  "tnoremap <a-h> <c-\><c-n><c-w>h
  "tnoremap <a-l> <c-\><c-n><c-w>l
  "au WinEnter *pid:* call feedkeys('i')
"endif

" nerdtree-git-plugin symbols{{{
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "⊕",
    \ "Untracked" : "⭒",
    \ "Renamed"   : "→",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ "Ignored"   : "◌",
    \ "Unknown"   : "?"
    \ }
"}}}

"set guifont=Meslo\ LG\ S\ DZ\ Regular\ for\ Powerline\ Nerd\ Font\ Complete\ Mono:h11
set guifont=Mononoki-Regular\ Nerd\ Font\ Complete\ Mono:h11

let g:webdevicons_enable = 1
" adding the flags to NERDTree 
let g:webdevicons_enable_nerdtree = 1

" use double-width(1) or single-width(0) glyphs
" only manipulates padding, has no effect on terminal or set(guifont) font
let g:WebDevIconsUnicodeGlyphDoubleWidth = 1

" Force extra padding in NERDTree so that the filetype icons line up vertically 
let g:WebDevIconsNerdTreeGitPluginForceVAlign = 1
let g:WebDevIconsNerdTreeAfterGlyphPadding = '  '

" enable folder/directory glyph flag (disabled by default with 0)
let g:WebDevIconsUnicodeDecorateFolderNodes = 1

let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1

let g:NERDTreeHighlightFolders = 1 " enables folder icon highlighting using exact match
let g:NERDTreeHighlightFoldersFullName = 1 " highlights the folder name

autocmd FileType nerdtree setlocal nolist

" Neomake ------------------------------------{{{

function! s:findRootPackageJsonFolder() abort
  " Try to use nearest first; findfile .; goes from current file upwards
  let l:filepath = findfile('package.json', '.;')
  if empty(l:filepath)
    return ''
  else
    return fnamemodify(resolve(expand(l:filepath)), ':h')
  endif
endfunction

" Sets b:neomake_javascript_enabled_makers based on what is present in the
" project
function! s:setupEslint() abort
    if !exists('b:neomake_javascript_eslint_exe')
      let l:rootFolder = s:findRootPackageJsonFolder()
      let l:eslint = l:rootFolder . '/node_modules/eslint/bin/eslint.js'
      if !empty(l:rootFolder)
        if filereadable(l:eslint)
          let b:neomake_javascript_eslint_exe = l:eslint
        else
          let b:neomake_javascript_eslint_exe = 'eslint'
        endif
      else
        let b:neomake_javascript_eslint_exe = 'eslint'
      endif
    endif
endfunction

autocmd! BufNewFile,BufReadPre * call s:setupEslint()

autocmd! BufWritePost,BufEnter * Neomake
let g:neomake_javascript_enabled_makers = ['eslint']
"let g:neomake_javascript_eslint_exe = system('npm root') .'/eslint/bin/eslint.js'
"let g:neomake_javascript_maker = 'npm run lint'
"let g:neomake_open_list = '2
"let g:neomake_javascript_eslint_maker = {
  "\ 'exe': 'yarn',
  "\ 'args': ['run', 'lint', '--', '-f', 'compact'],
  "\ 'errorformat': '%E%f: line %l\, col %c\, Error - %m,%W%f: line %l\, col %c\, Warning - %m'
  "\ }
let g:neomake_javascript_maker = {
  \ 'exe': 'yarn',
  \ 'args': ['run', 'lint', '--', '-f', 'compact'],
  \ 'errorformat': '%E%f: line %l\, col %c\, Error - %m,%W%f: line %l\, col %c\, Warning - %m'
  \ }


"}}}

" VimWiki ------------------------------------ {{{
let g:vimwiki_list = [{'path': '~/Dropbox/Private/vimwiki'}]
if has("win32unix")
  let g:vimwiki_list = [{'path': '~/vimwiki'}]
endif
"}}}

" Use DiffOrig to view diff after recovery --- {{{
  command DiffOrig vert new | set buftype=nofile | read ++edit # | 0d_ | diffthis | wincmd p | diffthis
"}}}

" fish seems to be slow to load, default to bash
set shell=/bin/bash
