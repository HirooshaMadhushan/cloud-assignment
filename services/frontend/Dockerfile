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
RUN chown -R appuser:appgroup /usr/share/nginx/html /var/cache/nginx /var/run /var/log/nginx

COPY --from=builder /build/build .
COPY nginx.conf /etc/nginx/conf.d/default.conf

USER appuser
EXPOSE 80
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost:80/health || exit 1

CMD ["nginx", "-g", "daemon off;"]