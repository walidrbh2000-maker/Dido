#!/bin/bash

set -e

echo "Installing dependencies..."
composer install --no-interaction --optimize-autoloader

echo "Running migrations..."
php artisan migrate --force

echo "Running seeders..."
php artisan db:seed --force

echo "Caching config..."
php artisan config:cache
php artisan route:cache

echo "Starting PHP-FPM..."
exec "$@"
