function saty-watch
	set filename (echo $argv[1] | sed 's/\.[^.]*$//')
	set skim_open 0
	fswatch -o $argv | while read -l
		echo "====================="

		satysfi {$filename}.saty
		if [ $status -ne 0 ]
			set_color red
			echo "Compile error."
			set_color normal
			continue
		end

		# dvipdfmx $filename

		if [ $skim_open -eq 0 -a -e $filename.pdf ]
			open -a Skim $filename.pdf
			set skim_open 1
		end
	end
end

