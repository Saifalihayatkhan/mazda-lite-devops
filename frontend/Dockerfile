# Use a lightweight Nginx image
FROM nginx:alpine

# Copy our HTML file to the default Nginx public folder
COPY index.html /usr/share/nginx/html/index.html

# Expose port 80 (standard web port)
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]