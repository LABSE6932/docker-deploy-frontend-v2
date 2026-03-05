# =========================
# Build Stage
# =========================
FROM node:22 AS build-stage

WORKDIR /app

# Copy lock files first (for better cache)
COPY package*.json ./

# Clean install dependencies
RUN npm install

# Copy source code
COPY . .

# Build with placeholder env (will be replaced at runtime)
RUN VITE_GRAPHQL_URI=__VITE_GRAPHQL_URI_PLACEHOLDER__ \
    VITE_SERVER_URI=__VITE_SERVER_URI_PLACEHOLDER__ \
    npm run build -- --mode production


# =========================
# Production Stage
# =========================
FROM nginx:alpine AS production-stage

# Remove default nginx config
RUN rm /etc/nginx/conf.d/default.conf

# Copy custom nginx config
COPY nginx-custom.conf /etc/nginx/conf.d/default.conf

# Copy built files from build-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Copy entrypoint script
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["/docker-entrypoint.sh"]