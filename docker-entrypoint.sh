#!/bin/bash
set -e

# Install Statamic if not already installed
if [ ! -f "composer.json" ]; then
    composer create-project statamic/statamic .
fi

# Install dependencies
composer install --no-interaction --optimize-autoloader --no-dev

# Set correct permissions
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html/storage
chmod -R 755 /var/www/html/content
chmod -R 755 /var/www/html/public/assets

# Generate application key if not exists
if [ ! -f ".env" ]; then
    cp .env.example .env
    php artisan key:generate
fi

# Start Apache in foreground
exec "$@"
