FROM node:18-bullseye

# working directory
WORKDIR /usr/src/app

# copy package files first
COPY . /usr/src/app

# install angular CLI with given command

RUN npm install -g @angular/cli
RUN npm install --verbose

# CMD commands (from dev.to article)
CMD ["ng", "serve", "--host", "0.0.0.0"]
