# CD Project

## Semantic Versioning:

- To see git `tags` in your github repo, navigate to the branches dropdown on the repo home page.
- There will be a section for tags as well where you can view the tags for this repo.
- To generate tags for the repo from the CLI, use the `git tag` command followed by the `v*` value that you would like to have as the version number.
    - Note: This step must be attached to a commit, so it is best practice to run this immediately after commiting and pushing a commit to the repo
- To push the tag that was just created, use the command `git push origin tagname`. This will push the tag just created to the main branch or origin.

## Workflow summary

- The workflow created for this part of the project. `main2.yml`, only triggers on tag pushes rather than any kind of push to the repo.
- This makes it so that new releases of the application will only bne pushed to dockerhub if a tag is added onto them with the correct tag syntax.


Workflow Steps:

1. Only triiger ON tag pushes with the format of v.*.*.*
2. Run on the ubuntu-latest runner
3. Checkout the repository using `actions/checkout@v4`
4. Use the `id: meta` with using `docker/metadata-action@v5` to get metadata about the image. Make sure to use the `${{ secrets.DOCKER_USERNAME }}/image-name` to collect the tags for this image
5. Use the secrets set up for this repo to login to dockerhub
6. Use `docker/build-push-action@v6` to build the docker image and push it to your docker repo

   - Use the `context` section to denore where your dockerfile is for building the image
   - Set the `push` section to true
   - add a `tags` under this, setting it to `${{ steps.meta.outputs.tags }}` to reference the tags pulled from the meta section
   - I added a `labels` section to the workflow file to stay consistent with the source. I believe this section is optional for the project tasks

- If using another repository please make sure to do the following:
    - Make sure secrets are created for the other repo
    - Have a valid dockerfile in the same place that context points to
    - Files needed for building the image must also be there since the dockerfile uses them
    - Set up a custom workflow in that repo with the same contents as this one, referencing its secrets and Dockerfile
 
Link to workflow file: https://github.com/WSU-kduncan/ceg3120-cicd-jailennn/blob/main/.github/workflows/main2.yml

To test that the workflow did its tasking, `git tag` a new commit to your repo anf then push that tag. Once this is done, check for the green check on github to appear for the workflow and a new image with the defined tags should appear on dockerhub.
 
To verify that the image is working and can run, `docker pull dockerusername/imagename ` with either the `V*` tag that you defined or latest, since that tag would have also been the latest tag on the image. This newly pulled image shpould contain updates from the commit an tag push done prior.

> Sources:
> https://github.com/docker/metadata-action?tab=readme-ov-file#images-input

> https://docs.github.com/en/actions/writing-workflows

> See main2.yml

---

# COntinuous Deployement

## EC2 Instance Details

- I used the `Ubuntu Server 24.04` AMI for this porject



---
