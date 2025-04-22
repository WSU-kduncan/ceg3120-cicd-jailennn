#!/bin/bash

# did this by combining commands from https://docs.docker.com/reference/cli/docker/ and adding my specific configuration.

echo "-- stopping and removing existing container --"
docker kill angular-app
docker rm angular-app ## removing it so that there arent name errors

echo "-- pulling latest image from DockerHub --"
docker pull wsujduncan/angular-bird:latest

echo "-- starting new container image --"
docker run -d --name angular-app -p 8080:4200 wsujduncan/angular-bird:latest

echo "-- done. New container version running --"
