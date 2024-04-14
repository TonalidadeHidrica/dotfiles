function powershell-tmux
	if type -q pwsh.exe
		set pwsh_exe pwsh.exe
	else
		set pwsh_exe powershell.exe
	end
	set original_pid $argv[1]
	$pwsh_exe -Command "\$env:WSL2_CURRENT_PID = $fish_pid; \$env:WSL2_PARENT_PID = $original_pid; $pwsh_exe"
end
