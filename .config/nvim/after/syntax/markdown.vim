" Markdown ファイル中の TeX 数式のハイライトをまともにする
" https://stackoverflow.com/questions/32865744/vim-syntax-and-latex-math-inside-markdown
" This gets rid of the nasty _ italic bug in tpope's vim-markdown
" block $$...$$
syn region markdownTexMath start=/\$\$/ end=/\$\$/
" inline math
syn match markdownTexMath '\$[^$].\{-}\$'
" actually highlight the region we defined as "math"
hi def link markdownTexMath Statement

" markdown 特有の末尾の空白(改行を意味する(は？))をハイライト
syntax match markdownWhitespaceNewline /  \+$/
hi def link markdownWhitespaceNewline DiffAdd

" markdown のコードを色付け
hi def link markdownCode markdownCodeDelimiter
