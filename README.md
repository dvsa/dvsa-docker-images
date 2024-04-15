# DVSA Base Images
Docker Images for use in DVSA projects 

## Adding a new base image

1. Create a new directory in the root of this repository with the name of the image you want to create. The convention is usually [language]/[version]/[flavour] e.g. `node/12/alpine`, `php/8.3/fpm-nginx` etc.

2. Create a `Dockerfile` in the directory you just created. This file should contain the instructions for building the image.

3. Update the `docker` job in `ci.yaml` and `cd.yaml` and update the matrix to add your new image. This ensures the image is build & pushed if it has changed (or during a new release).
    ```yaml
    strategy:
      fail-fast: false
      matrix:
        base:
          # ...
          - node/20/alpine
        exclude:
          # ...
          - base: ${{ needs.release-please.outputs.release_created || contains(needs.orchestrator.outputs.changed-directories, 'node/20/alpine') && 'ignored' || 'node/20/alpine' }}
    ```
