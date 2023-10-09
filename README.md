# dvsa-docker-images
Docker base Images for use in DVSA projects

The images will be used by all the base images used in the project. The github repo is structured to cater the multiple docker builds in a single repo 

`build` - Contains the the repo name for instance `vol-php-fpm` , if you want to create another docker image, create another folder and have your dockerfile in that folder along with any required files etc.

`scripts` - Scripts used in the workflow lives here

`.github/workflows` - It contians 2 workflows :

    `php-base-image-build-pr-main` runs on the PR request to main branch and perform the linting, security check and docker build

    `php-base-image-push-main` runs on the PR merge to main branch and performs the image signing, docker build and docker push

`build.json` - This is the file used by the workflow to perform the operation on multiple docker build operations, the workflow loop through the file and look for the parameter `build` if set to `true` the workflow performs the operation on only those images. so, please make sure to set this parameter as either `true | false`

###FAQ:
- How do I build another image in this repo ?
    Create a folder under build foder and name it with your repo name, place you place the dockerfile and other artifiacts required for building the image
    update the build.json file as follows :
    ```
    [
        {
            "registry": "php-base",
            "repoName": "vol-php-fpm",
            "dockerFile": "dockerfile",
            "tag": "7.4.0-alpine-fpm",
            "build": true
        },
        {
            "registry": "php-base",
            "repoName": "myreponame",
            "dockerFile": "dockerfile",
            "tag": "<mytag>",
            "build": true
        },
   ] 
   ```
   commit and test

