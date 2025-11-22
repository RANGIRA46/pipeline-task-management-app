# =================================================
# Backend API Dockerfile (Multi-stage)
# =================================================

# -------------------------------------------------
# Stage 1: Build - Compile TypeScript
# -------------------------------------------------
FROM node:20-alpine AS builder

# Install build dependencies
RUN apk add --no-cache python3 make g++

WORKDIR /app

# Copy package files
COPY backend/package*.json ./

# Install all dependencies (including dev for TypeScript compilation)
RUN npm ci

# Copy source code
COPY backend/ ./

# Build TypeScript to JavaScript
RUN npm run build

# -------------------------------------------------
# Stage 2: Runtime - Run compiled application
# -------------------------------------------------
FROM node:20-alpine

# Install wget for health checks
RUN apk add --no-cache wget

# Create non-root user for security
RUN addgroup -g 1001 -S nodejs && adduser -S nodejs -u 1001

WORKDIR /app

# Copy package files and install production dependencies only
COPY backend/package*.json ./
RUN npm ci --only=production && npm cache clean --force

# Copy compiled JavaScript from builder stage
COPY --from=builder --chown=nodejs:nodejs /app/dist ./dist

# Switch to non-root user
USER nodejs

# Expose API port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://localhost:3000/health || exit 1

# Environment variables (can be overridden at runtime)
ENV NODE_ENV=production \
    PORT=3000

# Start the application
CMD ["node", "dist/server.js"]
