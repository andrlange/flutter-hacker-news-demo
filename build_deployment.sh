#!/bin/bash
set -e

# Configuration variables
FLUTTER_APP_DIR=$(pwd)  # Change this to your Flutter app directory
OUTPUT_IMAGE_NAME="andrlange/flutter-hacker-news-app-demo"  # Name of the output container image
OUTPUT_IMAGE_TAG="latest"           # Tag for the output container image


echo "==== Flutter Web App Container Build Script ===="

# Step 1: Ensure Flutter is installed and available
if ! command -v flutter &> /dev/null; then
    echo "Flutter SDK not found. Please install Flutter and add it to your PATH."
    exit 1
fi

# Step 2: Navigate to Flutter app directory
echo "Navigating to Flutter app directory: $FLUTTER_APP_DIR"
cd "$FLUTTER_APP_DIR" || { echo "Flutter app directory not found"; exit 1; }

# Step 3: Get Flutter dependencies
echo "Getting Flutter dependencies..."
flutter pub get



# Step 4: Create a temporary directory for Paketo buildpack
TEMP_DIR="$FLUTTER_APP_DIR/build_tmp"
mkdir -p "$TEMP_DIR"
mkdir -p "$TEMP_DIR/public"
echo "Created temporary directory: $TEMP_DIR"

cd "$FLUTTER_APP_DIR"

# Step 5: Build Flutter for web
echo "Building Flutter web app..."
flutter build web --release -o "$TEMP_DIR/public"



# Step 6: Create an Nginx configuration file
echo "Creating Nginx configuration..."
cat > "$TEMP_DIR/nginx.conf" << 'EOF'
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /var/run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;
    sendfile on;
    keepalive_timeout 65;

    server {
        listen 8080;
        server_name localhost;
        root /workspace/public;
        index index.html;

        location / {
            try_files $uri $uri/ /index.html;
        }

        # Add gzip compression for better performance
        gzip on;
        gzip_types text/plain text/css application/json application/javascript application/x-javascript text/xml application/xml application/xml+rss text/javascript;

        # Handle Flutter routing
        location /assets/ {
            expires 30d;
            add_header Cache-Control "public, max-age=2592000";
        }
    }
}
EOF


# Step 7: build container using paketo
# Ensure we use local Docker daemon and disable any cloud registry authentication
echo "Building container image $OUTPUT_IMAGE_NAME:$OUTPUT_IMAGE_TAG with local-only settings..."
pack build $OUTPUT_IMAGE_NAME:$OUTPUT_IMAGE_TAG \
  --path $TEMP_DIR \
  --buildpack paketo-buildpacks/nginx \
  --builder paketobuildpacks/builder-jammy-base \
  --env BP_NGINX_CONF_LOCATION=nginx.conf \
  --env BP_WEB_SERVER=nginx \
  --trust-builder

# Step 8: Clean up
echo "Cleaning up temporary directory..."
rm -rf "$TEMP_DIR"
rm -rf /tmp/empty-docker-config
rm -rf /tmp/pack-home

echo "==== Build Complete ===="
echo "Your Flutter web app is now containerized with Nginx!"
echo "Run the container with: docker run -p 8080:8080 $OUTPUT_IMAGE_NAME:$OUTPUT_IMAGE_TAG"
echo "Access your application at: http://localhost:8080"