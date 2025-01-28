# Stage 1: Development
FROM node:20-alpine AS development

# Set working directory
WORKDIR /app

# Install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy all files
COPY . .

# Expose the development server port
EXPOSE 3000

# Start the development server
CMD ["npm", "run", "dev", "--", "--host"]

# Stage 2: Production
FROM node:20-alpine AS builder

# Set working directory
WORKDIR /app

# Install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy all files
COPY . .

# Build the project
RUN npm run build

# Stage 3: Serve Production
FROM node:20-alpine As production

# Set working directory
WORKDIR /app

# Copy built files from builder stage
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package.json ./
COPY --from=builder /app/package-lock.json ./

# Install production dependencies
RUN npm install --only=production
RUN npm install -g serve

# Expose the port
EXPOSE 3000

# Start the server
# CMD ["node", "./dist/server/entry.mjs"]
CMD ["serve", "dist", "-l", "3000"]


