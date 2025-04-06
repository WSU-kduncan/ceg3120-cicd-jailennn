# CI Project Overview

This project involves containerizing an Angular application named `angular-bird` and setting it up for continuous integration (CI) using Docker. The goal is to make the Angular application easy to deploy and manage by packaging it up in a container that can run on any system.

## What am I doing, why, and what tools?

### What:
I am containerizing an Angular application so that it can be deployed in any environment using Docker.

### Why:
- Docker ensures the app runs the same way in all environments.
- Docker containers can be easily pulled, pushed, and transferred between different systems.
- Docker has a very simple way of setting up dependencies and environments.

### Tools:
- **Docker:** Used for creating and managing containers.
- **Docker Hub:** To store and share Docker images.
- **Angular CLI:** serves the Angular application.

---

# Containerizing your Application

## How to Install Docker on Ubuntu:

1. Update your package list using `sudo apt-get update`

2. Install Docker and check version after using:

- `sudo apt-get install docker.io`
- `docker --version`

## How to build & configure a container (without building an image) that runs the angular-site application:

Use `docker pull` to pull the angular image from the docker hub website. After this, you can use `docker run` to run the image that was just pulled. Make sure to bind the port for the container to the same port on your device.

Inside the `Dockerfile`, I will configure the settings required to build an image from that file and run the angular bird package.

## Dockerfile Contents
1. The `FROM` portion of the docker file sets the base image for the rest of the instructions. The FROM must be at the beginnning of the dockerfile, using any valid image. I used the `node:18-bullseye` image similar to the example.
2. The `WORKDIR` section of this dockerfile sets where any `RUN` or `CMD` commands will be executed. This director wi;l be created inside the container instance if it does not already exist. I used a directory named `app` to hold my files.
3. The `COPY` section copies any files or directories from the current source to the destination which will be inside the container terminal. This will put those files in the specified destination on the COPY line. I copied both the `packagee` and the rest of the remaining files that were in the directory using the `.`  
4. The `RUN` section of the dockerfile specifies any commands that the user would like to run inside the container. I ran the commands `npm install` and `npm install -g @angular/cli@15.0.3` to install the angular CLI
5. The `EXPOSE` section of the dockerfile informs the docker what port the container will listen on. This is the port that will need to be connected to when testing if the setup is working. For my dockerfile, i used port `4200`
6. The `CMD` section is also for running commands specific to the container. The `["ng", "serve", "--host", "0.0.0.0"]` commands will run the ng serve and bind to any port.

> Resource: https://docs.docker.com/reference/dockerfile/#cmd

## How to build an image from the repository Dockerfile

To build a docket image from a dockerfile, use the `docker build` command with the -t flag to tag the image with something. Specify your dockerhub name and where you would like to place the image, along with the directory of where the dockerfile is. If the dockerfile is in the same directory when runnuing this command, use the `.` parameter at the end. Once this is finsiehd, run `docker images` to see your newly created image.

## How to run a container from the newly built image

To run a container of the docker image you jusr created, use the `docker run command` with some extra flags. Use the `-d` flag if you would like to run this container detached or in the background. Use the `-p` command to bind the container port to the port you would like to use on your system. You can also use the `--name` command to name the container something that you will remember instead of the random name given by docker. Lastly, put the name of the image you just created so that docker knows what image to run. After this, you should be able to use `docer ps` tp view the docker processes and see you container as up.

## How to view the application running in the container

Once the conatiner is up and running, find your local host IP adderess or use `localhost` to http to your container contents making sure to append `:port number` that you binded in the previous command. This should allow you to view your application running in the browser. 

---

# Docker Instructions


























