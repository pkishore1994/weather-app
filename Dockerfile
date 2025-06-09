# Use lightweight Node image
FROM node:14-alpine AS build

# Set working directory
WORKDIR /app

# Copy dependency definitions first for better caching
COPY package.json package-lock.json ./

# Install exact dependencies with npm ci (faster, more reliable)
RUN npm ci

# Copy all source files
COPY . .

# Disable source maps to reduce build size and memory
ENV GENERATE_SOURCEMAP=false

# Build the React app
RUN npm run build

# Use lightweight Nginx image to serve the built app
FROM nginx:alpine

# Copy build output to Nginx html directory
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
