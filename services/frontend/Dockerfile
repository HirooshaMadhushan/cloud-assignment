# --- Build stage ---
FROM node:20-alpine AS builder
WORKDIR /build
COPY package*.json ./
# Use `npm ci` when a lockfile exists, otherwise fall back to `npm install`
# `npm ci` fails the build if package-lock.json is missing; falling back keeps builds working
RUN npm ci || npm install --no-audit --no-fund --silent
COPY . .
RUN npm run build

# --- Runtime stage ---
FROM nginx:alpine
WORKDIR /usr/share/nginx/html

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Create a custom nginx.conf that works for non-root
RUN echo 'pid /tmp/nginx.pid;' > /etc/nginx/conf.d/pid.conf \
    && sed -i 's|/var/run/nginx.pid|/tmp/nginx.pid|g' /etc/nginx/nginx.conf \
    && sed -i 's|listen       80;|listen       8080;|g' /etc/nginx/conf.d/default.conf || true

# Pre-create necessary directories and fix permissions for non-root user
RUN mkdir -p /var/cache/nginx/client_temp \
             /var/cache/nginx/proxy_temp \
             /var/cache/nginx/fastcgi_temp \
             /var/cache/nginx/uwsgi_temp \
             /var/cache/nginx/scgi_temp \
             /var/log/nginx \
             /var/run/nginx \
    && chown -R appuser:appgroup /usr/share/nginx/html \
                                /var/cache/nginx \
                                /var/run \
                                /var/log/nginx \
                                /etc/nginx/conf.d

COPY --from=builder /build/build .
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Fix permissions for the copied config
RUN chown appuser:appgroup /etc/nginx/conf.d/default.conf

USER appuser
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost:8080/health || exit 1

CMD ["nginx", "-g", "daemon off;"]