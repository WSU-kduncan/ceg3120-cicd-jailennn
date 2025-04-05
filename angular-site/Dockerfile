FROM node:18-bullseye

# working directory
WORKDIR /app

# Install Angular CLI globally version 15
RUN npm install -g @angular/cli@15.0.3

# Copy and install dependencies
COPY package*.json ./
RUN npm install

# Copy everything
COPY . .

# expose port
EXPOSE 4200

# Run Angular app, binding to any IP
CMD ["ng", "serve", "--host", "0.0.0.0"]
