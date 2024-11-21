# First stage: Build
FROM node:20 AS build

# Set working directory in the build stage
WORKDIR /app

# Copy package.json and package-lock.json for dependency installation
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code into the container
COPY . .

# Second stage: Production-ready image
FROM node:20-alpine AS production

# Set the working directory in the production stage
WORKDIR /app

# Copy only the necessary files from the build stage
COPY --from=build /app /app


