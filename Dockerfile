FROM composer:2.0 as build
COPY . /app/
RUN composer install

FROM php:8.0.12-apache as production

ENV APP_ENV=production
ENV APP_DEBUG=false

RUN docker-php-ext-install pdo pdo_mysql

COPY --from=build /app/public /var/www/html

