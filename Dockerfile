FROM composer:2.0 as build

#copiamos codigo fuente
COPY . /app/

#ejecutamos composer para este proyecto (debemos estar en la raiz del código, y debe existir el composer.json)
RUN composer install

#instalamos extensión php para mysql
RUN docker-php-ext-install pdo pdo_mysql
#abrimos puerto 8000
EXPOSE 8000

#configuramos el container para que ejecute laravel en desarrollo:
CMD ["php", "artisan", "serve", "--host", "172.20.0.10"]

