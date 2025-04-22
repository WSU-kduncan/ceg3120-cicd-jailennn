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
2. Run on the `ubuntu-latest` runner
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

- To manually refresh the container if there is a new version available, fisrt use `docker ps` to find the name of the container that is currently up.
- Use `docker kill containername` to kill and stop that container from running.
- Use `docker pull dockerhubusername/imagename:latest` to pull the latest image of the application.
- Use the same `docker run` command from before to rerun the application with the new changes

> Sources:

> ChatGPT was used for verifying that the container is successfully serving the Angular application validate from container itself. I wasnt sure how to do that so I pasted that in to the AI and it gave me the `docker exec ... command`.

> https://docs.docker.com/reference/cli/docker/container/run/. Used this source for information on the docker run command and which flags to use

---

## Scripting container app refresh

To script the container app to update, use `vim scriptname.sh` to create a new script file. Enter the following lines into the script:

1. `docker kill currentrunningname`. This will stop the current running container. 
2. `docker rm currentrunningname`. This will remove that container from the list so it can be readded later.
3. `docker pull dockerusername/imagename:latest`. This will pull the latest image from dockerhub.
4. `docker run -d --name containername -p hostport:containerport dockerusername/imagename:latest`. This will run the image just pulled from dockerhub in a detached manner.

To verify that this script is working, use `chmod u+x scriptname.sh` to give yourself execute permissions on the script. Once this is done use `./scriptname.sh` to runn the script. After the script is ran, check the terminal output for success and also the browser the same way as earlier with `http://yourinstanceip:8080`.

> Link to bash script: https://github.com/WSU-kduncan/ceg3120-cicd-jailennn/blob/main/deployment/refresh.sh

---

## Configure webhook listener on the instance

- Run `sudo apt-get install webhook` to install webhook to the instance. RUn `webhoo --version` to make sure that it is installed.
- The webhook file in this repo is written in `.json` and contains the following:
    - `id` section is the name of the webhook that will be used in the payload sender to note where the webhook is going to. This can be any name and this will be loaded later when testing.
    - `execute-command` section specifies the path to the refresh script that will be ran when the payload comes in.
    - `response-message` section is an optional terminal output for ensuring that the script does run when the payload comes in.

To verify that the json is working with webhook, run the command `webhook -hooks hooksfile.json -verbose` and see if the webhook that you created loads. To verify that the webhook is recieving payloads that trigger it, use the command `curl -X POST http://instanceprivateip:9000/hooks/webhookid` from inside the terminal to simulate a POST request being sent to the instance. In the terminal that the webhook is running in, you should see the output saying the hook triggered and contents from the script should start to print out. The `docker ps` command should show a new image up for only a few seconds.

> Sources:

> https://docs.github.com/en/webhooks/using-webhooks/creating-webhooks

> https://github.com/adnanh/webhook

> ChatGPT was used for help with the response message to test working webhook and the curl -X command for simulating payloads.

> Link to definition json: https://github.com/WSU-kduncan/ceg3120-cicd-jailennn/blob/main/deployment/hooks.json 

---

## Payload sender

For my payload sender, I decided to use dockerhub. My reasoning behind selecting dockerhub as a payload sender is that I wanted the payload to send AFTER the new image came in so that the script can pull and run that new image. The dockerhub description of its webhooks directly says "`When an image is pushed to this repo, your workflows will kick off based on your specified webhooks.`"

To enable dockerhub to send payloads to the instance, navigate to the repository webhooks section on dockerhub and create a new webhook. This will ask you to give the webhook a name and a destination URL for the POST requests to go. As i said before, the event that triggers the payload sends for this project is when new images appear in the repository(from the github workflow).

To verify that a payload has successfully been delivered through dockerhub, either trigger the github workflow by creating a tag or manually push a new image to dockerhub. This will trigger the webhook on that repository and you should see the same output in the webhook the webhook terminal as you did when you generated the post request manually.

Sources: 

> https://docs.docker.com/docker-hub/repos/manage/webhooks/. Used this source formore information on exactly how payload sending/webhooks worked

---

## Listening Service

My service file has the following contents

1. `Description`: The description that will be given to the service. This will be listed on the status page of the service.
2. `After=network.target`: Specifies that the webhook service should start only after the network is up and running.
3. `ExecStart=/usr/bin/webhook -hooks /home/ubuntu/hooksname.json -verbose`: Defines the command to run when starting the service.
4.  `WorkingDirectory=/home/ubuntu`: Specifies the directory where the service will run from. Added this to ensure that pwd was ubuntu before continuing
5.  `Restart=always`: Instructs the system to always restart the service. This makes it so that the service will always restart if it is stopped.
6. `User=ubuntu`: Specifies the user under which the service should run. The only user on the instance will be ubuntu
7. `WantedBy=multi-user.target`: tells the system to start the webhook service when the system reaches the `multi-user.target` run level, which is typically when the system is fully booted and ready for multi-user operations. This ensures that the webhook listener starts automatically whenever the system boots up.

To enable and start the service you just created, run the following commands:
- `sudo systemctl daemon-reload`. This tells the systemd to read the service file
- `sudo systemctl enable servicefilename.service`. This will enable the systemd service so that you can start it
- `sudo systemctl start webhook.service`. This command will start the webhook service
- `sudo systemctl status webhook.service`. This will allow you to view the status of your servic, making sure it says running.

To verify that the service is capturing payloads and triggering the bash script, either manually push a new image to dockerhub or push a new tag to github to trigger the workflow. Either way, you should see the webhook service recieve the POST from dockerhub which then starts the script. Running the command `journalctl -u webhook.service -f` will show live logs of the service.


> Sources: AI(ChatGPT) was used in conjunction with to get the given [linux handbook](https://linuxhandbook.com/create-systemd-services/) source to get accurate descriptions of each line for my service file contents. The main source I used id not have any comments in its implementation (see webhooks.service file)

---

