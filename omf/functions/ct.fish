function ct
    ctags -R --languages=ruby --exclude=.git --exclude=log . (bundle list --paths)
end
