FROM composer:2.0 as build
COPY . /app/
RUN composer install

#abrimos puerto 8000
EXPOSE 8000

#configuramos el container para que ejecute laravel en desarrollo:
#ENTRYPOINT ["php", "artisan", "serve", "--host", "host.docker.internal"]
