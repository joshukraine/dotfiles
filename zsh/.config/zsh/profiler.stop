if [ -f $HOME/.zshrc.profiler ]; then
  unsetopt XTRACE
  echo ".zshrc profiling complete."
  exec 2>&3 3>&-
  echo "View top time consumers with: zshrc_profiler_view"
fi
