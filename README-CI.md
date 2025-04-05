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
- **Angular CLI:** Framework to build and serve the Angular application.

---

# Containerizing your Application

## How to Install Docker on Ubuntu:

1. Update your package list using `sudo apt-get update`

2. Install Docker and check version after using:

- `sudo apt-get install docker.io`
- `docker --version`

## How to build & configure a container (without building an image) that runs the angular-site application:

Use `docker pull` to pull the angular image from the docker hub website. After this, you can use `docker run` to run the image that was just pulled. Make sure to bind the port for the container to the same port on your device.
