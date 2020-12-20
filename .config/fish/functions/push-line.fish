# http://turanegaku.hateblo.jp/entry/2017/06/22/015349
# コマンドライン stash ができる

# Save this file to ~/.config/fish/functions/push-line.fish

# Bind the function by using this in ~/.config/fish/functions/fish_user_key_bindings.fish
# function fish_user_key_bindings
#   # For example alt+q
#   bind \eq push-line
# end

function push-line
  set cl (commandline)
  commandline -f repaint
  if test -n (string join $cl)
    set -g fish_buffer_stack $cl
    commandline ''
    commandline -f repaint

    function restore_line -e fish_postexec
      commandline $fish_buffer_stack
      functions -e restore_line
      set -e fish_buffer_stack
    end
  end
end
