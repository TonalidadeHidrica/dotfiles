" dein ---------------------------------
let s:dein_dir = expand('~/.vim/dein')
let s:toml_dir = expand('~/.config/nvim')
" dein ---------------------------------

" dein Scripts-----------------------------------------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " Immediate load
  call dein#load_toml(s:toml_dir . '/dein.toml', {'lazy': 0})

  " Lazy load
  call dein#load_toml(s:toml_dir . '/dein_lazy.toml', {'lazy': 1})

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

" Autommatically uninstall dein plugins
" https://hodalog.com/how-to-remove-plugin-using-dein/
let g:dein#auto_recache = 1
" dein Scripts-----------------------------------------------------------

set nu cb=unnamed
set backspace=indent,eol,start
syntax on
set nowrap
set ruler showcmd
" https://gist.github.com/Starefossen/5957088
set splitbelow splitright

noremap <ESC><ESC> :noh<CR>
noremap j gj
noremap k gk
noremap gj j
noremap gk k

" 2020/5/1
" True Color にできるらしい
" https://qiita.com/okamos/items/2259d5c770d51b88d75b
set termguicolors

command! -nargs=0 GradleDependencyToKts call GradleDependencyToKts()
function! GradleDependencyToKts()
  s/: \?/ = /g
  s/'/"/g
  s/\w\+\zs /(/
  s/$/)/g
endfunction

" Spellcheck
set spelllang=en,cjk
augroup spellcheckConfig
  autocmd FileType tex,plaintex setlocal spell wrap
augroup end

" v v v v v v v v v v v v v v v v v v v v v v v v v v v v v v

" Indents etc. 2019.12.14
" https://qiita.com/mitsuru793/items/2d464f30bd091f5d0fef
" https://peacepipe.toshiville.com/2006/05/vimrc-vim.html

" 'tabstop' (短縮名'ts')
" ファイル中の<Tab>文字(キャラクターコード9)を、
" 画面上の見た目で何文字分に展開するかを指定する。

" 'shiftwidth' (短縮名 'sw')
" vimが挿入するインデント('cindent')やシフトオペレータ(>>や<<)で
" 挿入/削除されるインデントの幅を、
" 画面上の見た目で何文字分であるか指定する。

" 'softtabstop' (短縮名'sts')
" キーボードで<Tab>キーを押した時に挿入される空白の量。

set tabstop=2 shiftwidth=2 softtabstop=2
set cindent noexpandtab

augroup fileTypeIndent
  autocmd!
  autocmd FileType python,julia setlocal shiftwidth=4 softtabstop=4 expandtab
  autocmd FileType haskell setlocal tabstop=8 shiftwidth=2 softtabstop=2 expandtab
  autocmd FileType vim setlocal expandtab
augroup end

" ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^

" 空白文字を表示
set list
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%
" 空白文字の色を変更
au ColorScheme,VimEnter * highlight NonText    ctermbg=None ctermfg=239 guibg=NONE guifg=#333333
au ColorScheme,VimEnter * highlight SpecialKey ctermbg=None ctermfg=239 guibg=NONE guifg=#333333

" 拡張子に応じて filetype を変更
" https://stackoverflow.com/a/28117335
" Set the filetype based on the file's extension, overriding any
" 'filetype' that has already been set
au BufRead,BufNewFile *.plt set filetype=gnuplot
au BufRead,BufNewFile *.tex set filetype=tex

" 大文字の K 入力したときなんか開くのやめろや
" https://unix.stackexchange.com/a/180927
noremap <S-k> <Nop>

" Ex モードに入らないようにする
nnoremap Q <Nop>

" Tab 補完で、いきなりすべての path を補完しない
" https://stackoverflow.com/a/526940/14795593
set wildmode=longest,list,full
set wildmenu

" Coc 用設定 vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K <cmd>call <SID>show_documentation()<CR>
vnoremap <silent> K <cmd>call <SID>show_documentation()<CR>
" vnoremap <silent> <buffer> K <cmd>call show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocActionAsync('doHover')
  endif
endfunction


" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
" xmap if <Plug>(coc-funcobj-i)
" omap if <Plug>(coc-funcobj-i)
" xmap af <Plug>(coc-funcobj-a)
" omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
" nmap <silent> <C-s> <Plug>(coc-range-select)
" xmap <silent> <C-s> <Plug>(coc-range-select)
" nmap <silent> <C-S> <Plug>(coc-range-select-backward)
" xmap <silent> <C-S> <Plug>(coc-range-select-backward)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" Format
nnoremap <silent><nowait> <space>f :Format<CR>

" Show function signature in arguments list
" https://github.com/neoclide/coc.nvim/issues/2202
inoremap <C-P> <C-\><C-O>:call CocActionAsync('showSignatureHelp')<cr>

" Extensions to install
let g:coc_global_extensions = [
      \ 'coc-json',
      \ 'coc-rust-analyzer',
      \ 'coc-pyright',
      \ 'coc-tsserver',
      \ 'coc-docker',
      \ 'coc-yaml',
      \ 'coc-grammarly',
      \ ]
" Coc 用設定 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

" カラースキーム
set background=dark
colorscheme hybrid

" vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
" Automatic reload from disk

" Triger `autoread` when files changes on disk
" https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
" https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
    autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
            \ if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif

" Notification after file change
" https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
" ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

" Debug syntax highlighting
" https://vim.fandom.com/wiki/Identify_the_syntax_highlighting_group_used_at_the_cursor
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

function! EditorialMode()
  set wrap expandtab spell
  wincmd l
  set wrap expandtab
  wincmd h
endfunction

" Show hidden files in NerdTree by default
let NERDTreeShowHidden=1

" nvim-treesitter settings
lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = {
    }
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
}
EOF

" Setup Python path, to enable neovim python support
" https://qiita.com/yuku_t/items/6db331e7084f88b43fe4
let g:python_host_prog=$HOME.'/.neovim-python-envs/2/.venv/bin/python'
let g:python3_host_prog=$HOME.'/.neovim-python-envs/3/.venv/bin/python'

" ## added by OPAM user-setup for vim / base ## 93ee63e278bdfc07d1139a748ed3fff2 ## you can edit, but keep this line
" let s:opam_share_dir = system("opam config var share")
" let s:opam_share_dir = substitute(s:opam_share_dir, '[\r\n]*$', '', '')
" 
" let s:opam_configuration = {}
" 
" function! OpamConfOcpIndent()
"   execute "set rtp^=" . s:opam_share_dir . "/ocp-indent/vim"
" endfunction
" let s:opam_configuration['ocp-indent'] = function('OpamConfOcpIndent')
" 
" function! OpamConfOcpIndex()
"   execute "set rtp+=" . s:opam_share_dir . "/ocp-index/vim"
" endfunction
" let s:opam_configuration['ocp-index'] = function('OpamConfOcpIndex')
" 
" function! OpamConfMerlin()
"   let l:dir = s:opam_share_dir . "/merlin/vim"
"   execute "set rtp+=" . l:dir
"   echo &rtp
" endfunction
" let s:opam_configuration['merlin'] = function('OpamConfMerlin')
" 
" let s:opam_packages = ["ocp-indent", "ocp-index", "merlin"]
" let s:opam_check_cmdline = ["opam list --installed --short --safe --color=never"] + s:opam_packages
" let s:opam_available_tools = split(system(join(s:opam_check_cmdline)))
" for tool in s:opam_packages
"   " Respect package order (merlin should be after ocp-index)
"   if count(s:opam_available_tools, tool) > 0
"     call s:opam_configuration[tool]()
"   endif
" endfor
" ## end of OPAM user-setup addition for vim / base ## keep this line

" 上のやつが遅いので、代用
" TODO opam バージョンとかが変わると死ぬ
set rtp+=$HOME/.opam/ocaml-base-compiler.4.10.0/share/merlin/vim
" Target is displayed in a new tab
let g:merlin_split_method = "tab"

" WSL 内の vim では unnamedplus を使う
" Windows 側に win32yank が必要
" 参考: https://github.com/equalsraf/win32yank
" https://github.com/neovim/neovim/wiki/FAQ#how-to-use-the-windows-clipboard-from-wsl
if has("unix")
  if filereadable("/proc/version")
    let lines = readfile("/proc/version")
    if lines[0] =~ "microsoft"
      set cb=unnamedplus
    endif
  endif
endif
