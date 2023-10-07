SHA=$(git rev-parse --short HEAD)
for results in $(jq -c '.[]' build.json); do

    repoName=$(echo "results" | jq -r '.repoName') 
    dockerFile=$(echo "results" | jq -r '.dockerFile') 
    tag=$(echo "results" | jq -r '.tag') 
    build=$(echo "results" | jq -r '.build')
    registry=$(echo "results" | jq -r '.registry')


    if [ "$build" == "true" ]; then
        echo "Building $repoName ..."
        buildTag="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$repo/$repoName:$tag-$SHA
        docker build -t $buildTag --file ./build/$repoName/$dockerFile build/.
    else
        echo "Not building - $repoName ,build parameter equal to false"
    fi

done
