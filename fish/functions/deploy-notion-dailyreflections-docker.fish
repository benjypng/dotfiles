function deploy-notion-dailyreflections-docker
    z notion-dailyreflections
    docker buildx build --platform=linux/amd64 -t notion-dailyreflections .
    docker tag notion-dailyreflections hkgnp/notion-dailyreflections
    docker push hkgnp/notion-dailyreflections
    say "Deployment done"
end
