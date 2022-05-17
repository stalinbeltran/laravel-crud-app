FROM composer:2.0 as build
COPY . /app/
RUN composer install

FROM php:8.0.12-apache as production

ENV APP_ENV=production
ENV APP_DEBUG=false

RUN docker-php-ext-install pdo pdo_mysql

COPY --from=build /app /var/www/html

#setear directorio de trabajo:
WORKDIR /var/www/html

RUN php artisan config:cache && \
    php artisan route:cache && \
    chmod 777 -R /var/www/html/storage/ && \
    chown -R www-data:www-data /var/www/ && \
    a2enmod rewrite
