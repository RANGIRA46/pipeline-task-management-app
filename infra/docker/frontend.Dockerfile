# =================================================
# Frontend UI Dockerfile (Multi-stage)
# =================================================

# -------------------------------------------------
# Stage 1: Build - Compile React/Vite
# -------------------------------------------------
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files
COPY frontend/package*.json ./

# Install dependencies
RUN npm ci

# Copy source code
COPY frontend/ ./

# Build argument for API URL
ARG VITE_API_URL=http://localhost:3000
ENV VITE_API_URL=$VITE_API_URL

# Build production bundle
RUN npm run build

# -------------------------------------------------
# Stage 2: Runtime - Serve with Nginx
# -------------------------------------------------
FROM nginx:stable-alpine

# Install wget for health checks
RUN apk add --no-cache wget

# Remove default Nginx static assets
RUN rm -rf /usr/share/nginx/html/*

# Copy custom Nginx configuration
COPY infra/docker/nginx.conf /etc/nginx/conf.d/default.conf

# Copy built React app from builder stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Create non-root user for Nginx
RUN touch /var/run/nginx.pid && \
    chown -R nginx:nginx /var/run/nginx.pid /var/cache/nginx /var/log/nginx /usr/share/nginx/html

# Switch to non-root user
USER nginx

# Expose HTTP port
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://localhost || exit 1

# Start Nginx (foreground mode)
CMD ["nginx", "-g", "daemon off;"]
