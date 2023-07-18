function git-autoclone
	if [ (count $argv) -lt 1 ]
		echo "Please specify the repository url."
		return 1
	end
	set url $argv[1]
	if set results (string match -r -- '^https://github.com/([\w-]+)/([\w-]+)/?$' $url)
		set protocol "https"
		set domain "github.com"
		set user $results[2]
		set name $results[3]
	else if set results (string match -r -- '^git@github.com:([\w-]+)/([\w-]+).git$' $url)
		set protocol "ssh"
		set domain "github.com"
		set user $results[2]
		set name $results[3]
	else
		echo "The URL could not be parsed."
		return 1
	end

	if [ -e ~/.config/fish/git-autoclone-config.txt ]
		for line in (cat ~/.config/fish/git-autoclone-config.txt)
			set arg (string split -- \t $line)
			if [ (count $arg) -ne 3 ]
				echo "There is a line in git-autoclone-config.txt that doesn't have exactly 3 items"
				return 1
			end
			if [ $protocol = "ssh" -a $domain = $arg[1] -a $user = $arg[2] ]
				set url "git@"$arg[3]":$user/$name"
				break
			end
		end
	end

	echo "Domain:     $domain"
	echo "Username:   $user"
	echo "Repository: $name"
	echo "Url:        $url"

	cd
	set dir "dev/git/com/github/$user"
	mkdir -p $dir
	cd $dir
	git clone $url
	cd $name
end
