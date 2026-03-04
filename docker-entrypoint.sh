#!/bin/sh

echo "Replacing environment variables..."

# Replace placeholders in built JS files
find /usr/share/nginx/html -type f -name "*.js" -exec \
  sed -i "s|__VITE_GRAPHQL_URI_PLACEHOLDER__|${VITE_GRAPHQL_URI}|g" {} \;

find /usr/share/nginx/html -type f -name "*.js" -exec \
  sed -i "s|__VITE_SERVER_URI_PLACEHOLDER__|${VITE_SERVER_URI}|g" {} \;

echo "Starting Nginx..."
nginx -g "daemon off;"