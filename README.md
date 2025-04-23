## Overall Repo Overview - Jailen Duncan

This repository contains all the necessary files and configuration for a fully automatic CI/CD integration for a Angular website application that is deployed using Docker images on an AWS instance.

---

## Contents of This Repository

1. `development/`: Contains deployment related files such as the `webhook.service` system file, and the `refresh.sh` script file used to stop/restart containers.
2. `.github/workflows`: This path direcory contians the `main2.yml` file holding the workflow definition for this repo. THis file defines what will happen when tags get pushed to the repo.
3. `Dockerfile`: Defines the build instructions for the Docker image, including the base image, build steps, and how the app is served over the prots.
4. `angular-site`: THe directory containing all of the actual website configuration and files so that this can be built from the dockerfile in the repo.
5. `README-CI.md`: Covers the GitHub Actions setup, Docker image build and workflow steps
6. `README-CD.md`: Explains DockerHub webhook usage, EC2 listener service, and automatic redeployment process.

Link to CI Documentation: https://github.com/WSU-kduncan/ceg3120-cicd-jailennn/blob/main/README-CI.md

Link to CD Documentation: https://github.com/WSU-kduncan/ceg3120-cicd-jailennn/blob/main/README-CD.md
