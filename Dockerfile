FROM node:18-bullseye

# working directory
WORKDIR /app

# copy package files first
COPY . /app

# install angular CLI with given command

RUN npm install -g @angular/cli

RUN npm install

# CMD commands (from dev.to article)
CMD ["ng", "serve", "--host", "0.0.0.0"]
