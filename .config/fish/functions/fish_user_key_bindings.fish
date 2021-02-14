function fish_user_key_bindings
	# Disable C-d binding
	bind --erase --preset \cd
	bind --erase --mode insert --preset \cd
	bind --erase --mode visual --preset \cd
end
