#!/bin/bash

echo "-- Stopping and removing existing container --"
docker kill angular-ct
docker rm angular-ct

echo "-- Pulling latest image from DockerHub --"
docker pull wsujduncan/angular-bird:latest

echo "-- Starting new container --"
docker run -it --name angular-ct -p 8080:4200 wsujduncan/angular-bird:latest

echo "-- Done. New container version running --"
