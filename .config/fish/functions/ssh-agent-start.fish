function ssh-agent-start
	eval (ssh-agent -c)
	ln -sf $SSH_AUTH_SOCK ~/.ssh/ssh-agent-socket
	chmod 700 ~/.ssh/ssh-agent-socket
	set SSH_AUTH_SOCK ~/.ssh/ssh-agent-socket
end
