# Builder
FROM node:18 AS builder
WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# Runtime
FROM node:18-alpine
WORKDIR /app

COPY --from=builder /app ./

ENV NODE_ENV=production
ENV PORT=8787

EXPOSE 8787

# Azure injects SESSION_SECRET into env at runtime
CMD ["npm", "start"]
