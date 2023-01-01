" markdown 特有の末尾の空白(改行を意味する(は？))をハイライト
" vim-markdown の助けを借りる
hi link mkdLineBreak DiffAdd

" \\( から始まり \\) で終わる領域、及び \\[ から始まり \\] で終わる領域も、
" 数式としてハイライトする
if get(g:, 'vim_markdown_math', 0)
  syn region mkdMath start="\\\zs\\("  end="\\\\)"  contains=@tex keepend
  syn region mkdMath start="\\\zs\\\[" end="\\\\\]" contains=@tex keepend
endif
