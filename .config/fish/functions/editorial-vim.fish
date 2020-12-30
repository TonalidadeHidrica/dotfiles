function editorial-vim
	vim -O -c"call EditorialMode()" {$argv[1]}en.md $argv[1].md
end

