function open_vim
	vim -c"e ++enc=euc-jisx0213" $argv
end

function pukiwiki-vim
	if [ (count $argv) -lt 1 ]
		echo "Usage: pukiwiki-vim [page name]"
		return 1
	end
	set filename (echo -n $argv[1] | iconv -t EUC-JISX0213 | xxd -p | tr -d '\n' | tr [:lower:] [:upper:]).txt
	if [ -e $PWD/$filename ]
		open_vim $filename
	else if [ -e $PWD/wiki/$filename ]
		open_vim wiki/$filename
	else
		echo "File not found, expected "$filename
	end
end
