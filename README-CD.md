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

- I used the `Ubuntu Server 24.04` AMI for this project, along with a `t2.medium` type instance
- The reccomended volume size for this project is `30 GB`

## Security Groups
- The security group rules configured for this project are as follows. I made these rules to be able to accomplish all given tasks in the project:
- All of the rules below are inbound rules coming INTO the instance. 
- Port 22 (SSH): Opened this port to WSU addresses only so I can ssh into it while on campus.
- Port 80 (Webhook Listener): I opened this port to anywhere so that the instance can recieve the POST resquest from the webhook configured on DockerHub. Port 443  could have also been opened here for HTTPS but I did not go there for this project.
- Port 8080 (Connect to app in browser): I also opened this port from anywhere so that any IP can view the image/ new app running in the browser.

> Source: https://docs.docker.com/docker-hub/repos/manage/webhooks/. Used to confirm that webhooks use HTTP(port 80)

## Docker Setup on Ubuntu Instance

- Run the following commands to install docker on the instance
- `sudo apt update`
- `sudo apt install -y docker.io`
- These will update the terminal and install docker
- `docker run hello-world`. This command will pull and run the latest endition of the hello-world image. THis is for testing it docker is working on the instance.

- Additonal: Run `sudo usermod -aG docker ubuntu` to put the ubuntu user in the group that avoids having to use sudo for every docker command. You must exit and ssh back into the instance for this to take effect.

## Testing docker on EC2 instance

- To pull a container image from a dockerhub repo, run the command `docker pull dockerhubusername/imagename:tag`. If no tag is given, it will defailt to latest
- Use `docker images` to see if the pulled image is now available on your instance
- Once confirmed that the image is there, use `docker run -it -p host-port:container-port dockerhubusername/imagename` to run the image just pulled

- the `-p` flag maps the port on the instance to the port in the container. Since I used 8080 in my security groups I will be using that in my command.
- The `-d` or the `-it` flags can be used to run the container in detached mode or interactively in the terminal, respectively. -it attaches your terminal to the container which is good for debugging. -d is used to run detached and is what I would reccomen to use once testing is done.

- To verify that the application is working and serving content from the container itself, run the command `docker exec -it containername  curl http://localhost:4200`. This command should return the html from the app home page.
- From the host side(The instance), use the command `curl http://localhost:8080` to curl the html contents of the page. Note that since this instance is the one hosting the page/container, local host : the host port defined in the `docker run` command should dispaly the html.
- To verify that the app is working from another system, open any browser and type in `http://<IntancePublicIP:8080` to see the actual webpage contents not just the html text.


> Sources:

> ChatGPT was used for verifying that the container is successfully serving the Angular application validate from container itself. I wasnt sure how to do that so I pasted that in to the AI and it gave me the `docker exec ... command`.

> https://docs.docker.com/reference/cli/docker/container/run/. Used this source for information on the docker run command and which flags to use

---
