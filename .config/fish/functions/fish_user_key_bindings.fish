function fish_user_key_bindings
	# Disable C-d binding
	bind --erase --preset \cd
	bind --erase --mode insert --preset \cd
	bind --erase --mode visual --preset \cd
	# Esc + L が暴発するので、削除
	bind --erase --preset \el
	bind --erase --mode insert --preset \el
	bind --erase --mode visual --preset \el
end
