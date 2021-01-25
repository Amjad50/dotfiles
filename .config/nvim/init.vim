
set nocompatible

if !exists('g:vscode')
    " VimPLug
    call plug#begin('~/.vim/plugged')

    " look and feel
    Plug 'itchyny/lightline.vim'
    Plug 'machakann/vim-highlightedyank'
    " Plug 'kjwon15/vim-transparent'

    " integrations
    Plug 'airblade/vim-gitgutter'

    " rust
    Plug 'rust-lang/rust.vim'
    " toml
    Plug 'cespare/vim-toml'

    " completion
    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    " colorschemes 
    " Plug 'joshdick/onedark.vim'
    " Plug 'altercation/solarized'
    " Plug 'lifepillar/vim-solarized8'
    Plug 'tomasiser/vim-code-dark'

    " Discord RPC integration
    " Plug 'hugolgst/vimsence'

    call plug#end()

    " Lightline
    let g:lightline = {
          \ 'active': {
          \   'left': [ [ 'mode', 'paste' ],
          \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
          \ },
          \ 'component_function': {
          \   'filename': 'LightlineFilename',
          \   'cocstatus': 'coc#status'
          \ },
          \ 'colorscheme': 'codedark',
          \ }

    function! LightlineFilename()
      return expand('%:t') !=# '' ? @% : '[No Name]'
    endfunction

    " Use auocmd to force lightline update.
    autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

    " #GUI
    " colors
    if !has('gui_running')
      set t_Co=256
    endif
    "" if (match($TERM, "-256color") != -1) && (match($TERM, "screen-256color") == -1)
    ""   " screen does not (yet) support truecolor
    ""   set termguicolors
    "" endif
    set termguicolors

    " set background=dark
    colorscheme codedark
    " TransparentDisable
    " TransparentDisable
    syntax on

    hi Pmenu ctermbg=gray guibg=Gray

    " numbers
    set number relativenumber

    " show signbar
    highlight! link SignColumn LineNr
    set signcolumn=yes

    " show column on 80
    set colorcolumn=80

    " wrapping
    set nowrap

    " gui vim
    set guioptions-=m  " remove the menubar
    set guioptions-=T  " remove the toolbar

    " hide showing mode from vim itself, it is handled by lightline
    set noshowmode

    " gitgutter coloring
    highlight GitGutterAdd    guifg=#009900 ctermfg=2
    highlight GitGutterChange guifg=#bbbb00 ctermfg=3
    highlight GitGutterDelete guifg=#ff2222 ctermfg=1


    " # Preferences
    " tabs
    set tabstop=4
    set softtabstop=4
    set shiftwidth=4
    set expandtab
    set smarttab
    set autoindent

    " wildmenu
    set wildmenu

    " faster updates
    set updatetime=200
    set timeoutlen=300

    " searching
    set incsearch
    set ignorecase
    set smartcase
    set hlsearch

    " replacement
    set gdefault

    " better splits
    set splitright
    set splitbelow

    " mouse control
    set mouse=a

    " show hidden chars
    set listchars=nbsp:¬,extends:»,precedes:«,trail:•

    " tree view for netrw folder view
    let g:netrw_liststyle=3
    let g:netrw_browse_split=3
    let g:netrw_preview=1
    let g:netrw_alto=0
    let g:netrw_banner=0


    " #Languages
    let g:rustfmt_autosave = 1
    let g:rustfmt_emit_files = 1
    let g:rustfmt_fail_silently = 0
    " let $RUST_SRC_PATH = systemlist("rustc --print sysroot")[0] . \"/lib/rustlib/src/rust/src"

    " helper functions
    function Show_documentation()
      if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
      else
        call CocAction('doHover')
      endif
    endfunction

    " formatting go files, the reason I did not use govim or vim-go is because
    " I'm used to coc mappings and its nice to have one plugin for all language
    " completing
    " autocmd BufWritePost *.go silent call Go_fmt()
    function Go_fmt()
        :!go fmt %
        :e
    endfunction

    " #Autocommands

    " enable spelling by default for git commit message editing
    autocmd FileType gitcommit :set spell
endif

" #Mappings
let mapleader=","

" No arrow keys --- force yourself to use the home row
noremap <up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Switch between tabs
noremap <C-PageDown> gt
noremap <C-PageUp> gT

" Switch between buffers
noremap <C-Right> :bn<CR>
noremap <C-Left> :bp<CR>

" remove search highlight
noremap <C-h> :nohlsearch<CR>


if !exists('g:vscode')
    " show documentation
    noremap <C-j> :call Show_documentation()<CR>

    " Coc
    " navigation in code: main char 'g'
    nmap <silent> [c <Plug>(coc-diagnostic-prev)
    nmap <silent> ]c <Plug>(coc-diagnostic-next)

    nmap <silent> cd <Plug>(coc-definition)
    nmap <silent> cy <Plug>(coc-type-definition)
    nmap <silent> ci <Plug>(coc-implementation)
    nmap <silent> cr <Plug>(coc-references)
        
    " trigger auto complete
    inoremap <silent><expr> <C-Space> coc#refresh()

    " renaming
    nmap <leader>rn <Plug>(coc-rename)

    " show actions
    nnoremap <silent> <leader>a :CocAction<CR>

    " GitGutter maps: main char 'g'
    " hunk switch
    nmap ]g <Plug>(GitGutterNextHunk)
    nmap [g <Plug>(GitGutterPrevHunk)

    " stage and undo
    nmap gs <Plug>(GitGutterStageHunk)
    nmap gu <Plug>(GitGutterUndoHunk)

    " preview
    nmap gp <Plug>(GitGutterPreviewHunk)
else

    " show documentation
    noremap <C-j> :call VSCodeNotify('editor.action.showHover')<CR>

    " code navigation
    nmap ]c :call VSCodeNotify('editor.action.marker.next')<CR>
    nmap [c :call VSCodeNotify('editor.action.marker.prev')<CR>
    nmap <silent> cd :call VSCodeNotify('editor.action.revealDefinition')<CR>
    nmap <silent> cr :call VSCodeNotify('editor.action.goToReferences')<CR>

    " renaming
    nmap <leader>rn :call VSCodeNotify('editor.action.rename')<CR>

    " show actions
    nnoremap <silent> <leader>a :call VSCodeNotify('editor.action.quickFix')<CR>

    " hunk switch
    nmap ]g :call VSCodeNotify('workbench.action.editor.nextChange')<CR>
    nmap [g :call VSCodeNotify('workbench.action.editor.previousChange')<CR>

    " stage and undo
    nmap gs :call VSCodeNotify('git.stageSelectedRanges')<CR>
    nmap gu :call VSCodeNotify('git.revertSelectedRanges')<CR>
    
    " preview
    nmap gp :call VSCodeNotify('workbench.action.editor.previousChange')<CR>
endif

" save
nmap <leader>w :w<CR>


" Search results centered please
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz
