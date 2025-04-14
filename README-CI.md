# CI Project Overview

This project involves containerizing an application named `angular-bird` and setting it up using Docker. The goal is to make the angular bird application easy to deploy and manage by packaging it up in a container that can run on any system.

## What am I doing:
I am containerizing an Angular application so that it can be deployed in any environment using Docker.

### Why?:
- Docker ensures the app runs the same way in all environments.
- Docker images can be easily pulled, pushed, and transferred between different systems.

### Tools:
- **Docker:** Used for creating and managing containers.
- **Docker Hub:** To store and share Docker images.
- **Angular:** serves the Angular application.

---

# Containerizing the Application

## How to install Docker on Ubuntu:

> Before doing this, you must install the WSL2 app on your windows system.

1. Update your package list using `sudo apt-get update`

2. Install Docker and check version after using:

- `sudo apt-get install docker`
- `docker --version`

## How to build & configure a container manually (without building an image):

Use `docker pull angular/ngcontainer` to pull the angular image from the docker hub website. After this, you can use `docker run` command to run the image that was just pulled. Make sure to use the `-p hostport:containerport` top bind the port for the container to a port on your device.

When inside the angular application, you may need to use `npm install` to get additional dependencies or packages or this container. You will also need to use the `ng serve` commmand to actually start the application inside of the container.

To prove that this is working on the client side, you should see some output in the container saying it is complete and successful, along with a link pouinting to where you can test if it is working on the host side. The host side link should have a URL connecting to the same port you binded earlier in the commands.

## Dockerfile Contents

Inside the `Dockerfile`, I will configure the settings required to build an image from that file and run the angular bird package.

1. The `FROM` portion of the docker file sets the base image for the rest of the instructions. The FROM must be at the beginnning of the dockerfile, using a valid image. I used the `node:18-bullseye` image similar to the example.
2. The `WORKDIR` section of this dockerfile sets where any `RUN` or `CMD` commands will be executed. This director wi;l be created inside the container instance if it does not already exist. I used a directory named `app` to hold my files.
3. The `COPY` section copies any files or directories from the current source to the destination which will be inside the container terminal. This will put those files in the specified destination on the COPY line. I copied both the `packagee` and the rest of the remaining files that were in the directory using the `.`  
4. The `RUN` section of the dockerfile specifies any commands that the user would like to run inside the container. I ran the commands `npm install` and `npm install -g @angular/cli@15.0.3` to install the angular CLI
5. The `EXPOSE` section of the dockerfile informs the docker what port the container will listen on. This is the port that will need to be connected to when testing if the setup is working. For my dockerfile, i used port `4200`
6. The `CMD` section is also for running commands specific to the container. The `["ng", "serve", "--host", "0.0.0.0"]` commands will run the ng serve and bind to any port.

## How to build an image from the repository Dockerfile

To build a docket image from a dockerfile, use the `docker build` command with the -t flag to tag the image with something. Specify your dockerhub name and where you would like to place the image, along with the directory of where the dockerfile is. If the dockerfile is in the same directory when runnuing this command, use the `.` parameter at the end. Once this is finsiehd, run `docker images` to see your newly created image.

## How to run a container from the newly built image

To run a container of the docker image you jusr created, use the `docker run command` with some extra flags. Use the `-d` flag if you would like to run this container detached or in the background. Use the `-p` command to bind the container port to the port you would like to use on your system. You can also use the `--name` command to name the container something that you will remember instead of the random name given by docker. Lastly, put the name of the image you just created so that docker knows what image to run. After this, you should be able to use `docker ps` to view the docker processes and see you container as up.

## How to view the application running in the container

Once the conatiner is up and running, find your local host IP adderess or use `localhost` to http to your container contents making sure to append `:port number` that you binded in the previous command. This should allow you to view your application running in the browser. 

For the client side, the terminal should begin outputting the contents from angular and will eventually say `** Angular Live Development Server is listening on 0.0.0.0:portbind, open your browser on http://localhost:portbind/ **`. Once you see this in the terminal, you should be able to go to the browser using the above instructions to connect to the application.

> Resources below were used for information on how to specifically configure the Dockerfile contents for this project, and some of the docker commands to work with that dockerfile.

> https://docs.docker.com/reference/dockerfile/

> https://dev.to/rodrigokamada/creating-and-running-an-angular-application-in-a-docker-container-40mk

---

# Docker Instructions

To create a public repo in dockerhub, navigate to the website or to the docker desktop application and sign in. Once you do that, go to your profile and click the repositories icon. This should open up the button to `Create a repository`. Create the repository, making sure to select the public view button. 

To create a Personal Access Token (PAT) for your Docker account, navigate to the dockerhub website and go to you account settings. There, you should see the PAT section where you can create one for your account. The PAT requires a description, expiration date, and access rules. Once this is done, use the `docker login -u yordockeruser` to login to docker form the command line. This will prompt you for either the password to that user or you can paste your PAT in place of the password. 

Before you can push an image, you must log in using your DockerHub credentials. To do this, run the `docker login` command and enter your dockerhub account information. Once you are signed in, you can use the `docker psuh` command to push your image to the docker hub website where it can be viewed. 

> Resources below were used for information on Dockerhub and how to setup the repository and login steps.

> https://docs.docker.com/reference/cli/docker/login/

> Link to my docerhub repo: https://hub.docker.com/repositories/wsujduncan

> Note: when pushing, dockerhub pushed this image to its own seperate repo, rather than under the one I created :(

---

# Part 2: GitHub Actions and DockerHub

1. Create a DockerHub Personal Access Token (PAT)
   - To create a Personal Access Token (PAT) for your Docker account, navigate to the dockerhub website and go to you account settings. There, you should see the PAT section where you can create one for your account. The PAT requires a description, expiration date, and access rules. The scope I elected to use for this project was read/write only. I used this because I only need will need to pull(read) or push (write). 
     > Note: This was copied from above since same question was asked.
2. Create Github Action Secrets in Github Repo
   - To create action secrets in github, navigate to you github repo and go to the repo settings. After this, navigate to `secrets and variables` section and create a new repository secret under actions. Create two secrets here, pasting your dockerhub username in one and the PAT you just generated in the other.
3. The secrets for this porject are used by the Actions workflow to log in to DockerHub and push images without exposing the login credentials.

