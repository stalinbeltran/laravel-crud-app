FROM composer:2.0 as build

#copiamos codigo fuente
COPY . /app/
RUN composer install

#abrimos puerto 8000
# EXPOSE 8000

#configuramos el container para que ejecute laravel en desarrollo:
CMD ["php", "artisan", "serve", "--host", "172.17.0.2"]
CMD ["ifconfig"]

