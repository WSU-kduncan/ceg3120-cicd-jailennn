#!/bin/bash

# did this by combining commandsfrom https://docs.docker.com/reference/cli/docker/ 

echo "-- stopping and removing existing container --"
docker kill angular-ct
docker rm angular-ct ## removing it so that there arent name errors

echo "-- pulling latest image from DockerHub --"
docker pull wsujduncan/angular-bird:latest

echo "-- starting new container image --"
docker run -it --name angular-ct -p 8080:4200 wsujduncan/angular-bird:latest

echo "-- done. New container version running --"
