FROM node:22.14.0-bookworm-slim

WORKDIR /app

# Copy package files first for better caching
COPY package*.json ./

# Install dependencies
RUN npm ci

# Only install PostgreSQL client if your npm scripts need it
RUN apt-get update && apt-get install -y postgresql-client && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

# Copy application code
COPY . .

# Build the application
RUN npm run build

EXPOSE 3001

CMD ["npm", "start"]