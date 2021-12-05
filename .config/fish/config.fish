set LOCAL_FISH (dirname (status --current-filename))/local.fish
if [ -e $LOCAL_FISH ]
  source $LOCAL_FISH
end

# pipenv の補完
# eval (pipenv --completion)

# これ必要？
if [ -e /usr/local/Caskroom/miniconda/4.6.14/miniconda3/bin/conda ]
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval (eval /usr/local/Caskroom/miniconda/4.6.14/miniconda3/bin/conda "shell.fish" "hook" $argv)
# <<< conda initialize <<<
end

if which conda > /dev/null
  # これはなに（config.fishを書くときはちゃんと記録残してくれ）
  source (conda info --root)/etc/fish/conf.d/conda.fish
end

# ssh-agent の環境変数を固定する
set SSH_AUTH_SOCK ~/.ssh/ssh-agent-socket
export SSH_AUTH_SOCK  # ←この行がないと肝心の ssh-agent に環境変数が行かないよ！
# SSH_AGENT_PID は諦めです

# fish shell vi-like key bindings
fish_vi_key_bindings

# tree コマンドを必ず色付け(-C)、日本語表示可能に(-N: show character as-is)
alias tree="tree -CN"
# less コマンドを必ずas-isで表示(色付け出力とかを色がついた状態で受け取る)(-X)
alias less="less -R"

# Escキー（正確にはMetaキー）が押されたあと、それが「Esc」と解釈されるまでのミリ秒数
# Meta+Something は一生使わないと仮定して、 0ms に……しようかとおもったらできないらしいんで、 10ms にする
set fish_escape_delay_ms 10

# さよならvim、こんにちはneovim
alias vim=nvim
alias ovim='\\vim'

# # Fish
# set -g fish_user_paths "/usr/local/opt/libpq/bin" $fish_user_paths

if [ -e /.opam/opam-init/init.fish ]
  # opam configuration
  source $HOME/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true
end

# Homebrew Command Not Found
#https://github.com/Homebrew/homebrew-command-not-found
# Mac 環境で、存在しないコマンドを打ったときにコマンドの所在を教える (to use this command, install ...)
if type -q brew
   set HB_CNF_HANDLER (brew --repository)"/Library/Taps/homebrew/homebrew-command-not-found/handler.fish"
   if test -f $HB_CNF_HANDLER
      source $HB_CNF_HANDLER
   end
end

# PHPBrew
# https://github.com/phpbrew/phpbrew/blob/master/README.ja.md
source /Users/seasellsheshell/.phpbrew/phpbrew.fish
