FROM node:18-bullseye

# working directory
WORKDIR /app

# copy package files first
COPY angular-site/package*.json ./

# install angular CLI with given command

RUN npm install --verbose

RUN npm install -g @angular/cli

# Copy the rest of the project files
COPY angular-site ./

# CMD commands (from dev.to article)
CMD ["ng", "serve", "--host", "0.0.0.0"]
