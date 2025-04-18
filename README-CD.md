# CD Project

## Semantic Versioning:

- To see git `tags` in your github repo, navigate to the branches dropdown on the repo home page.
- There will be a section for tags as well where you can view the tags for this repo.
- To generate tags for the repo from the CLI, use the `git tag` command followed by the v* that you would like to have as the version number.
    - Note: This step must be attached to a commit, so it is best practice to run this immediately after commiting and pushing a commit to the repo
- To push the tag that was just created, use the command `git push origin tagname`. This will push the tag just created to the main branch or origin.

## Workflow summary

- The workflow created for this part of the project. `main2.yml`, only triggers on tag pushes rather than any kind of push to the repo.
- This makes it so that new releases of the application will only bne pushed to dockerhub if a tag is added onto them with the correct tag syntax.


Workflow Steps:

1. 
2. 



- If using another repository please make sure to do the following:
    - Make sure secrets are created for the other repo
    - Have a valid dockerfile in the same place that context points to
    - Files needed for building the image must also be there since the dockerfile uses them
    - Set up a custom workflow in that repo with the same contents as this one, referencing its secrets and Dockerfile
  




> Sources:
> https://github.com/docker/metadata-action?tab=readme-ov-file#images-input
> 
