FROM composer:2.0 as build
COPY . /app/
RUN composer install
