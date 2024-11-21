FROM node AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
FROM node:20-alpine
WORKDIR /app
# Copy the installed dependencies and application code from the build stage
COPY --from=build /app /app