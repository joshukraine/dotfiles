# PATH - https://fishshell.com/docs/current/tutorial.html#tut_path
set -g fish_user_paths "/sbin" $fish_user_paths
set -g fish_user_paths "/usr/sbin" $fish_user_paths
set -g fish_user_paths "/bin" $fish_user_paths
set -g fish_user_paths "/usr/bin" $fish_user_paths
set -g fish_user_paths "/usr/local/sbin" $fish_user_paths
set -g fish_user_paths "/usr/local/bin" $fish_user_paths
set -g fish_user_paths "$HOME/bin" $fish_user_paths

fish_vi_key_bindings
