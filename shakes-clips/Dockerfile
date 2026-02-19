# Use official PHP image with Apache
FROM php:8.2-apache

# Copy website files into Apache root
COPY . /var/www/html/

# Install database extensions (PostgreSQL & MySQL)
RUN docker-php-ext-install pdo pdo_mysql pdo_pgsql mysqli

# Give proper permissions
RUN chown -R www-data:www-data /var/www/html

# Expose port 80
EXPOSE 80
