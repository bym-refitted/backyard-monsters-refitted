# ===============================
# Build stage
# ===============================
FROM node:22.14.0-bookworm-slim AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install ALL dependencies (including dev deps for building)
RUN npm ci

# Install PostgreSQL client for build/migration scripts
RUN apt-get update && apt-get install -y postgresql-client && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

# Copy source code
COPY . .

# Build the application
RUN npm run build

# ===============================
# Production stage
# ===============================
FROM node:22.14.0-alpine AS production

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install ONLY production dependencies
RUN npm ci --only=production && npm cache clean --force

# Copy assets and built files from the builder stage
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/public ./public 

EXPOSE 3001

CMD ["npm", "start"]