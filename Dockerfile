FROM node:10.12 AS builder

WORKDIR /app
RUN apt-get update &&  apt-get install -y expect
COPY package*.json ./
RUN npm install --silent --no-audit
COPY . .
RUN npm run build
LABEL maintainer="helder@taikai.network"

FROM node:10.12-alpine AS release

WORKDIR /app
COPY package*.json ./
COPY . .
RUN mkdir -p logs
RUN apk add expect
RUN npm install --silent --only=production --no-audit
COPY --from=builder /app/build build
CMD NODE_ENV=production npm run serve --build --port 80 --host 0.0.0.0

