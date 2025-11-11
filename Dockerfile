# ---- Builder ----
FROM node:16.17.0 AS builder
WORKDIR /app

# Copy package files first for caching
COPY package*.json ./

# Install dependencies (full install: dev + prod)
RUN npm install

# Copy full source code
COPY . .

# Create environment file required at build time
RUN echo "SESSION_SECRET=\${SESSION_SECRET}" > .env

# Build Next.js app
RUN npm run build


# ---- Runtime ----
FROM node:16.17.0-alpine

WORKDIR /app

# Copy built app from builder
COPY --from=builder /app /app

# Expose the port JSONHero runs on
EXPOSE 8787

# Required runtime environment vars (Azure injects these)
ENV NODE_ENV=production
ENV PORT=8787

CMD ["npm", "start"]
