#!/bin/bash

set -e

echo "Installing dependencies..."
composer install --no-interaction --optimize-autoloader

echo "Running migrations..."
php artisan migrate --force

echo "Running seeders..."
php artisan db:seed --force

# ── Keys (must happen before config:cache) ────────────────────────────────────

APP_KEY=$(grep -E "^APP_KEY=" /var/www/html/.env 2>/dev/null | cut -d= -f2 | tr -d '[:space:]')
if [ -z "$APP_KEY" ]; then
    echo "APP_KEY missing — generating..."
    php artisan key:generate --force
    echo "APP_KEY generated."
fi

JWT_SECRET=$(grep -E "^JWT_SECRET=" /var/www/html/.env 2>/dev/null | cut -d= -f2 | tr -d '[:space:]')
if [ -z "$JWT_SECRET" ]; then
    echo "JWT_SECRET missing — generating..."
    php artisan jwt:secret --force
    echo "JWT_SECRET generated."
fi

# ── Cache (now safe to run) ───────────────────────────────────────────────────

echo "Caching config..."
php artisan config:cache
php artisan route:cache

echo "Starting PHP-FPM..."
exec "$@"
