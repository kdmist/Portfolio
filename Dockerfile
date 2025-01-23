# Base image
FROM node:20-alpine3.19 AS base
WORKDIR /app
COPY --chown=node:node package*.json ./
RUN npm ci

# Development image
FROM base AS development
COPY --chown=node:node . .
EXPOSE 3000

# Build stage
FROM base AS builder
COPY --chown=node:node . .
RUN npm run build

# Production stage
FROM node:20-alpine3.19 AS production
WORKDIR /app
COPY --from=builder /app/package.json /app/package.json
COPY --from=builder /app/dist /app/build
RUN npm install

USER node
EXPOSE 3000
CMD ["node", "build/index.js"]
