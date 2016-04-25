set nocompatible  " Use Vim settings, rather then Vi settings
set nobackup
set nowritebackup
set history=200
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set incsearch     " do incremental searching
set vb            " NO BELLS
set laststatus=2  " Always display the status line
set mousefocus    "gvim mouse select pane
set shell=/bin/sh "Ensure that vim always runs from a shell https://rvm.io/integration/vim

""" FOR POWER/AIR/STATUSLINE
set encoding=utf-8 " Necessary to show Unicode glyphs
set guifont=Menlo\ For\ Powerline
let g:airline_powerline_fonts=1
" powerline symbols
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''



let g:javascript_conceal_function   = "ƒ"
let g:javascript_conceal_null       = "ø"
let g:javascript_conceal_this       = "@"
let g:javascript_conceal_return     = "⇚"
let g:javascript_conceal_undefined  = "¿"
let g:javascript_conceal_NaN        = "ℕ"
let g:javascript_conceal_prototype  = "¶"
let g:javascript_conceal_static     = "•"
let g:javascript_conceal_super      = "Ω"


" Treat Underscores as Keywords such that hitting e and b will jump to the
" next underscore instead of the full word.
" set iskeyword-=_

" Turn on the WiLd menu
set wildmenu

" Ignore compiled files
set wildignore+=*.o,*~,*.pyc
set wildignore+="bin/*"
set wildignore+="build/*"

"command-t - change dir to current"
"set autochdir

call pathogen#infect()
"let g:pathogen_disabled = ["vaxe"]

"Hightlight common typos
syn match typos "udpate"
syn match typos "affiliatied"
syn match typos "deparment"
syn match typos "ouput"
syn match typos "withing"
hi def link typos Error


" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

filetype plugin indent on

set backspace=indent,eol,start

" Settings for VimClojure
let vimclojure#HighlightBuiltins=1      " Highlight Clojure's builtins
let vimclojure#ParenRainbow=1           " Rainbow parentheses'!


augroup vimrcEx
  au!
  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
augroup END


" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set expandtab
autocmd Filetype html setlocal ts=2 sts=2 sw=2
autocmd Filetype ruby setlocal ts=2 sts=2 sw=2
autocmd Filetype javascript setlocal ts=4 sts=4 sw=4
autocmd Filetype haxe setlocal ts=4 sts=4 sw=4

"Treat Wisp and Lisp-ish files as Clojure
autocmd BufNewFile,BufRead *.ls   set filetype=clojure
autocmd BufNewFile,BufRead *.ws   set filetype=clojure

"Treat Clojure-JS files as Clojure
autocmd BufNewFile,BufRead *.cljs   set filetype=clojure
autocmd BufNewFile,BufRead *.hiccup set filetype=clojure

"Treat javascript template files like html
autocmd BufNewFile,BufRead *.ejs set filetype=html
autocmd BufNewFile,BufRead *.hbs set filetype=html

" Set auto test run per filetype
func! SetAutoTestOnSave()
  autocmd BufWritePost *.ex,*.exs !mix test
  autocmd BufWritePost *_spec.rb  !rspec %
  autocmd BufWritePost *_spec.clj !lein spec
endfunc
map <leader>aa :call SetAutoTestOnSave()


" Display extra whitespace
set list listchars=tab:»·,trail:·

" Local config
if filereadable("~/.vimrc.local")
  source ~/.vimrc.local
endif

" Use Ack instead of Grep when available
if executable("ack")
  set grepprg=ack\ -H\ --nogroup\ --nocolor
endif

" Delete trailing white space on save
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc

autocmd BufWrite *.clj    :call DeleteTrailingWS()
autocmd BufWrite *.py     :call DeleteTrailingWS()
autocmd BufWrite *.rb     :call DeleteTrailingWS()
autocmd BufWrite *.erb     :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()
autocmd BufWrite *.js     :call DeleteTrailingWS()
autocmd BufWrite *.py     :call DeleteTrailingWS()
autocmd BufWrite *.hx     :call DeleteTrailingWS()

" Color scheme
colorscheme Tomorrow-Night-Eighties
highlight NonText guibg=#060606
highlight Folded  guibg=#0A0A0A guifg=#9090D0

" Numbers
set number
set numberwidth=5

" Snippets are activated by Shift+Tab
let g:snippetsEmu_key = "<S-Tab>"

" Tab completion options
set wildmode=list:longest,list:full
set complete=.,w,t

" Tags
let g:Tlist_Ctags_Cmd="ctags --exclude='*.js'"

" Cucumber navigation commands
autocmd User Rails Rnavcommand step features/step_definitions -glob=**/* -suffix=_steps.rb
autocmd User Rails Rnavcommand config config -glob=**/* -suffix=.rb -default=routes
" :Cuc my text (no quotes) -> runs cucumber scenarios containing "my text"
command! -nargs=+ Cuc :!ack --no-heading --no-break <q-args> | cut -d':' -f1,2 | xargs bundle exec cucumber --no-color

" Ge off my lawn
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>


" Elm Shortcuts
nnoremap <leader>el :ElmEvalLine<CR>
vnoremap <leader>es :<C-u>ElmEvalSelection<CR>
nnoremap <leader>ep :ElmPrintTypes<CR>
nnoremap <leader>em :ElmMakeCurrentFile<CR>

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" HAXE THINGS
" munit tests
map <leader>bt  :! haxelib run munit test -kill-browser<cr>
map <leader>bbt :! haxelib run munit test <cr>
map <leader>br  :! haxe compile<cr>
" nme compile targets
map <leader>b  :! openfl test flash<cr>
map <leader>bb :! openfl test mac<cr>
map <leader>bi :! openfl update ios -debug<CR>

" autosave haxe files on autocompletion
au FileType haxe setl autowrite

" set vaxe default plugin to cpp
if !exists("g:vaxe_nme_target")
  let g:vaxe_nme_target = "cpp"
endif

"map Control-r to :make for vaxe build
map <leader>R :make<CR>
"map Control-b to select target for vaxe build
map <leader>r call vaxe#NmeTargets()<CR>


function! ToggleEnablePreview()
  if &l:completeopt =~ 'preview'
    return
  else
    let opts = split(&l:completeopt, ',')
    if &l:completeopt =~ 'preview'
      let opts = filter(opts, 'v:val != "preview"')
      echo "disabling omnifunc preview"
    else
      let opts += ['preview']
      echo "enabling omnifunc preview"
    endif
    let &l:completeopt = join(opts,',')
  endif
endfunction



"Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 1
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplete#close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

" For cursor moving in insert mode(Not recommended)
"inoremap <expr><Left>  neocomplete#close_popup() . "\<Left>"
"inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
"inoremap <expr><Up>    neocomplete#close_popup() . "\<Up>"
"inoremap <expr><Down>  neocomplete#close_popup() . "\<Down>"
" Or set this.
"let g:neocomplete#enable_cursor_hold_i = 1
" Or set this.
"let g:neocomplete#enable_insert_char_pre = 1

" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType c             setlocal omnifunc=ccomplete#Complete
autocmd FileType ruby          setlocal omnifunc=rubycomplete#Complete
autocmd FileType css           setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType java          setlocal omnifunc=javacomplete#Complete
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript    setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python        setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml           setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType clojure       setlocal omnifunc=clojurecomplete#Complete
autocmd FileType haxe          setlocal omnifunc=vaxe#HaxeComplete

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.ruby    = '[^. *\t]\.\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.haxe   = '\v([\]''"]|\w)(\.|\()'
let g:neocomplete#sources#omni#input_patterns.haxe    = '\%([\]''") ]\|\w\)\%(\.\|(\)'
" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

" Use neocomplete.vim
let g:neocomplete#sources#omni#input_patterns = {
\   "ruby" : '[^. *\t]\.\w*\|\h\w*::',
\}






"""""" Vim TagBar
map <leader>tt        :TagbarToggle<CR>
"""""" NERDTree
map <leader><leader>  :NERDTreeToggle<CR>


nnoremap <ESC><ESC> :w<CR>


" Toggle Paste
nnoremap <F5> :set invpaste paste?<CR>
set pastetoggle=<F5>
set showmode

"Use TAB to complete when typing words, else inserts TABs as usual.
"Uses dictionary and source files to find matching words to complete.

"See help completion for source,
"Note: usual completion is on <C-n> but more trouble to press all the time.
"Never type the same word twice and maybe learn a new spellings!
"Use the Linux dictionary when spelling is in doubt.
"Window users can copy the file to their machine.
"function! Tab_Or_Complete()
"  if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
"    return "\<C-N>"
"  else
"    return "\<Tab>"
"  endif
"endfunction
"inoremap <Tab> <C-R>=Tab_Or_Complete()<CR>
"set dictionary="/usr/dict/words"

"""" NERD TREE
"" Open Nerd Tree when vim starts
autocmd vimenter * NERDTree | call feedkeys("\<C-\>\<C-n>\<c-w>l", 'n')
"" Close vim when only open window is nerd tree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

let NERDTreeIgnore = ['(node_modules|bower_components)$']

function! Toggle_Color_Scheme()
  if g:colors_name == "Tomorrow"
    colorscheme Tomorrow-Night-Eighties
  else
    colorscheme Tomorrow
  end
endfunction
map <leader>f :call Toggle_Color_Scheme()<CR>

function! RunSingleSpec()
    exec '!rspec % -l ' . line('.')
endfunction
"map <leader>t :call RunSingleSpec()<CR>
let g:rubytest_in_quickfix = 1


" xmpfilter keymaps
nmap <buffer> <S-C-R> <Plug>(xmpfilter-run)
xmap <buffer> <S-C-R> <Plug>(xmpfilter-run)
imap <buffer> <S-C-R> <Plug>(xmpfilter-run)

nmap <buffer> <S-C-J> <Plug>(xmpfilter-mark)
xmap <buffer> <S-C-J> <Plug>(xmpfilter-mark)
imap <buffer> <S-C-J> <Plug>(xmpfilter-mark)


" Syntastic settings
let g:syntastic_ruby_checkers=['mri']
let g:syntastic_ruby_exec='ruby'
let g:syntastic_check_on_open=1
let g:syntastic_enable_signs=1
let g:syntastic_echo_current_error=1
let g:syntastic_enable_balloons = 1

let g:syntastic_javascript_checkers = ['jsxhint']

let g:syntastic_error_symbol='✘'
let g:syntastic_warning_symbol='>'

"Control-P
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/node_modules/*,*/bower_components/*     " MacOSX/Linux
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows


"" Auto resize current pane on enter
"autocmd BufEnter * call s:ResizeSplit()
"command ResizeSplit call s:ResizeSplit()
"function! s:ResizeSplit()
"  if (winheight(0) < &lines / 3)
"    :res (&lines / 3)
"  endif
"  if (winwidth(0) < &columns / 3)
"    :vertical resize (&columns / 3)
"  endif
"endfunction

" Set and unset wrap based on split width
autocmd BufEnter * call s:SetWrap()
function! s:SetWrap()
  if (winwidth(0) < 90)
    :set nowrap
  else
    :set wrap
  endif
endfunction

" Insert a hash rocket with <c-l>
function! AddHashRocket()
  if(getline(".")[col(".")-1] == '\s')
    return "=>\<space>"
  else
    return "\<space>=>\<space>"
  endif
endfunction
inoremap <c-l> <c-r>=AddHashRocket()<cr>

" Protect large files from sourcing and other overhead.
" Files become read only
if !exists("my_auto_commands_loaded")
  let my_auto_commands_loaded = 1
  " Large files are > 10M
  " Set options:
  " eventignore+=FileType (no syntax highlighting etc
  " assumes FileType always on)
  " noswapfile (save copy of file)
  " bufhidden=unload (save memory when other file is viewed)
  " buftype=nowritefile (is read-only)
  " undolevels=-1 (no undo possible)
  let g:LargeFile = 1024 * 1024 * 10
  augroup LargeFile
    autocmd BufReadPre * let f=expand("<afile>") | if getfsize(f) > g:LargeFile | set eventignore+=FileType | setlocal noswapfile bufhidden=unload buftype=nowrite undolevels=-1 | else | set eventignore-=FileType | endif
    augroup END
  endif

"vim-detailed
colo detailed



autocmd GuiEnter * set background&

set ttimeoutlen=100
set ttyfast
set lazyredraw

:au CursorMoved
autocmd BufReadPost quickfix map <buffer> <leader>qq :cclose<cr>|map <buffer> <c-p> <up>|map <buffer> <c-n> <down>
set synmaxcol=120
set nocursorline
set re=1
:redraw
