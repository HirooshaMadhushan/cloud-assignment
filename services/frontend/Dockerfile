# --- Build stage ---
FROM node:20-alpine AS builder
WORKDIR /build
COPY package*.json ./
RUN npm config set fetch-retries 5 \
    && npm config set fetch-retry-mintimeout 20000 \
    && npm config set fetch-retry-maxtimeout 120000 \
    && if [ -f package-lock.json ]; then \
         npm ci --prefer-offline --no-audit --no-fund; \
       else \
         npm install --prefer-offline --no-audit --no-fund; \
       fi
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
