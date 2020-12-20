function git-autoclone
	if [ (count $argv) -lt 1 ]
		echo "Please specify the repository url."
		return 1
	end
	if set results (string match -r -- "^https://github.com/([\w-]+)/([\w-]+)/?" $argv[1])
		set user $results[2]
		set name $results[3]
	else if set results (string match -r -- "^git@github.com:([\w-]+)/([\w-]+).git" $argv[1])
		set user $results[2]
		set name $results[3]
	else
		echo "The URL could not be parsed."
		return 1
	end

	echo "Domain:     github.com"
	echo "Username:   $user"
	echo "Repository: $name"

	cd
	set dir "dev/git/com/github/$user"
	mkdir -p $dir
	cd $dir
	git clone $argv[1]
	cd $name
end
