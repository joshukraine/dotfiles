c() { cd ~/dev/projects/$1;  }

_c() { _files -W ~/dev/projects -/; }
compdef _c c

h() { cd ~/$1; }
_h() { _files -W ~/ -/; }
compdef _h h

# add plugin's bin directory to path
# export PATH="$(dirname $0)/bin:$PATH"
