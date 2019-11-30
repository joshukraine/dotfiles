function gbrm
  git branch --merged master | grep -v "^\*\|  master" | xargs -n 1 git branch -d
end
