FROM node:18-bullseye

# working directory
WORKDIR /app

# copy package files first
COPY package*.json .

# copy everything else from this directory to container WORKDIR
COPY . . 

# install angular CLI with given command

RUN npm install

RUN npm install -g @angular/cli



# CMD commands (from dev.to article)
CMD ["ng", "serve", "--host", "0.0.0.0"]
