function git-show
	git show --word-diff-regex=(echo 5b5e802dbf5d5b802dbf5d2a|xxd -r -p) $argv
end
