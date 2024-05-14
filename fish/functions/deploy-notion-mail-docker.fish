function deploy-notion-mail-docker
    z notion-mail
    docker buildx build --platform=linux/amd64 -t notion-mail .
    docker tag notion-mail hkgnp/notion-mail
    docker push hkgnp/notion-mail
    say "Deployment done"
end
