# --- Build stage ---
FROM node:20-alpine AS builder
WORKDIR /build
COPY package*.json ./
RUN npm ci || npm install --no-audit --no-fund --silent
COPY . .
RUN npm run build

# --- Runtime stage ---
FROM nginx:alpine
WORKDIR /usr/share/nginx/html

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY --from=builder /build/build .
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Fix ownership of the static files
RUN chown -R appuser:appgroup /usr/share/nginx/html

USER appuser
EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
