# Dockerfile for a Rails application using Nginx and Unicorn

# Select ubuntu as the base image
FROM nginx
COPY nginx.conf /etc/nginx/nginx.conf
# Add configuration files in repository to filesystem
COPY nginx-sites.conf /etc/nginx/sites-enabled/default

RUN echo "daemon off;" >> /etc/nginx/nginx.conf

EXPOSE 80

CMD ['nginx']
