function ygs -d "Build a Nuxt site and serve from the dist/ folder."
    yarn generate
    and http-server dist/ -p 8080
end
