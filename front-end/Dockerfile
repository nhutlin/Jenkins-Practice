FROM node:20 AS build

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

FROM node:20-alpine AS production

WORKDIR /app

COPY --from=build /app /app

