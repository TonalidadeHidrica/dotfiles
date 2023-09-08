function ssh-agent-start
	argparse 'f/force' -- $argv
	or return 1

	if type -q timeout
		timeout 0.3 ssh-add -l >/dev/null 2>&1
	else if type -q gtimeout
		gtimeout 0.3 ssh-add -l >/dev/null 2>&1
	else
		echo "Warning: Neither timeout nor gtimeout was found."
		echo "This may result in an inaccurate detection on whether ssh-add is running."
		echo "On mac, install gtimeout with `brew install coreutils`."
		ssh-add -l >/dev/null 2>&1
	end
	if [ $status -ne 2 ]
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
