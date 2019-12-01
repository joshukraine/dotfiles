function gl
  git log --date=format:"%b %d, %Y" --pretty=format:"%C(yellow bold)%h%Creset%C(white)%d%Creset %s%n %C(blue)%aN (%cd)%n"
end
