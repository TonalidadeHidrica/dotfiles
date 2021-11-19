function ssh-agent-start
	argparse 'f/force' -- $argv
	or return 1

	if [ -e ~/.ssh/ssh-agent-socket ]
		if set -lq _flag_force
			echo "SSH agent seems to be already running, but starting another process."
		else
			echo "SSH agent seems to be already running."
			echo "Use -f to use force restart."
			return 1
		end
	end

	eval (ssh-agent -c)
	ln -sf $SSH_AUTH_SOCK ~/.ssh/ssh-agent-socket
	chmod 700 ~/.ssh/ssh-agent-socket
	set SSH_AUTH_SOCK ~/.ssh/ssh-agent-socket
end
