# ===============================
# Base image
# ===============================
FROM oven/bun:latest
WORKDIR /app

# Copy package definitions and install all deps
# (devDependencies needed for mikro-orm CLI)
COPY package.json bun.lock ./
RUN bun install

# Copy source and static files
COPY src ./src
COPY public ./public

EXPOSE 3001

CMD ["bun", "src/server.ts"]
