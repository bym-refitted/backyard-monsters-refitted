# ===============================
# Base image (shared)
# ===============================
FROM oven/bun:latest AS base
WORKDIR /app

# ===============================
# Dependencies stage (cacheable)
# ===============================
FROM base AS deps

# Copy package definitions first
COPY package.json bun.lock ./

# Install production dependencies only
# You can add --frozen-lockfile for reproducible installs
RUN bun install --production

# ===============================
# Build stage
# ===============================
FROM base AS builder

# Copy everything for build
COPY . .

# Install all dependencies including devDependencies
RUN bun install

# If your build requires additional tools like Postgres client:
RUN apt-get update && \
    apt-get install -y postgresql-client && \
    rm -rf /var/lib/apt/lists/*

# Build your app
RUN bun run build

# ===============================
# Production stage
# ===============================
FROM base AS production

WORKDIR /app

# Copy only production deps
COPY --from=deps /app/node_modules /app/node_modules

# Copy build output
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/public ./public

# If your app relies on other static assets
# COPY --from=builder /app/static ./static

ENV NODE_ENV=production

EXPOSE 3001

CMD ["bun", "run", "start"]
