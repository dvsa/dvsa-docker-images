SHA=$(git rev-parse --short HEAD)

# Iterate over JSON objects in build.json
jq -c '.[]' build.json | while read -r results; do

    repoName=$(echo "$results" | jq -r '.repoName') 
    dockerFile=$(echo "$results" | jq -r '.dockerFile') 
    tag=$(echo "$results" | jq -r '.tag') 
    build=$(echo "$results" | jq -r '.build')

    if [ "$build" == "true" ]; then
        echo "Building $repoName ..."
        buildTag="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$repoName:$tag-$SHA"
        docker build -t "$buildTag" --file "./build/$repoName/$dockerFile" build/.
    else
        echo "Not building - $repoName, build parameter equal to false"
    fi
done
