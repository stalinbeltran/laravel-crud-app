FROM composer:2.0 as build
COPY . /app/
RUN composer install

#abrimos puerto 8000
EXPOSE 8000
