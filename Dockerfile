# Use the official PHP image with required extensions
FROM php:8.2-fpm

# Set working directory
WORKDIR /var/www

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git curl zip unzip libonig-dev libxml2-dev libzip-dev \
    libpng-dev libjpeg-dev libfreetype6-dev \
    libmcrypt-dev libpq-dev libmysqlclient-dev \
    && docker-php-ext-install pdo pdo_mysql zip mbstring exif pcntl bcmath gd \
    && apt-get clean

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copy project files (after building Tailwind locally)
COPY . .

# Install Laravel PHP dependencies (without dev packages)
RUN composer install --no-dev --optimize-autoloader

# Set proper permissions
RUN chown -R www-data:www-data /var/www \
    && chmod -R 775 /var/www/storage /var/www/bootstrap/cache

# Expose port if using internal PHP server (optional)
EXPOSE 9000

# Start PHP-FPM (not Laravel serve, let Nginx or PHP-FPM handle)
CMD ["php-fpm"]
