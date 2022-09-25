function glg
    git log --graph --stat --date=format:"%b %d, %Y" --pretty=format:"%C(yellow bold)%h%Creset%C(white)%d%Creset %s%n%C(blue)%aN <%ae> | %cd%n"
end
