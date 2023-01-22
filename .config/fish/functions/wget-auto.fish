function wget-auto
	if [ (count $argv) != 1 ]
		echo "Usage: wget [URL]" 1>&2
		return 1
	end
	set url $argv[1]
	set domain (echo $url | sed -e 's/[^/]*\/\/\([^@]*@\)\?\([^:/]*\).*/\2/')
	set domains (string split '.' $domain)
	set reverse_domain (string join '.' $domains[-1..1])

	mkdir -p ~/dl
	cd ~/dl
	mkdir -p $reverse_domain
	cd $reverse_domain
	wget $url
end
