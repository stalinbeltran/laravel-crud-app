# laravel-crud-app

Create PHP Laravel 8 CRUD web application with MySQL Database.

[Create PHP Laravel 8/7 CRUD Web App with MySQL Database](https://www.positronx.io/php-laravel-crud-operations-mysql-tutorial/)


# Registro de Eventos durante la immplementación:

1. Al tener en docker-compose.yml este volumen:

    volumes:
      - ./public :/var/www/html

y tratar de crear los containers con el comando:
docker compose up -d
obtenemos el error:

C:\desarrollo\pruebasDocker\laravel-crud-app>docker compose up -d
[+] Running 0/1
 - Container 4b9715a67b89_4b9715a67b89_4b9715a67b89_laravel-crud-app-app-1  Recreate                                0.1s
Error response from daemon: The system cannot find the file specified.


2. Al corregir docker-compose.yml con:

    volumes:
      - .:/var/www/html

y al compilar:
docker compose up -d --build

C:\desarrollo\pruebasDocker\laravel-crud-app>docker compose up -d --build
[+] Building 9.0s (13/13) FINISHED
 => [internal] load build definition from Dockerfile                                                                0.0s
 => => transferring dockerfile: 283B                                                                                0.0s
 => [internal] load .dockerignore                                                                                   0.0s
 => => transferring context: 2B                                                                                     0.0s
 => [internal] load metadata for docker.io/library/php:8.0.12-apache                                                0.0s
 => [internal] load metadata for docker.io/library/composer:2.0                                                     3.1s
 => [auth] library/composer:pull token for registry-1.docker.io                                                     0.0s
 => [internal] load build context                                                                                   2.9s
 => => transferring context: 651.46kB                                                                               2.9s
 => CACHED [build 1/3] FROM docker.io/library/composer:2.0@sha256:b3703ad1ca8e91a301c2653844633a9aa91734f3fb278c56  0.0s
 => [production 1/3] FROM docker.io/library/php:8.0.12-apache                                                       0.0s
 => [build 2/3] COPY . /app/                                                                                        1.0s
 => [build 3/3] RUN composer install                                                                                1.7s
 => CACHED [production 2/3] RUN docker-php-ext-install pdo pdo_mysql                                                0.0s
 => CACHED [production 3/3] COPY --from=build /app/public /var/www/html                                             0.0s
 => exporting to image                                                                                              0.1s
 => => exporting layers                                                                                             0.0s
 => => writing image sha256:6cc495d39f5c2a3ac72776ea155aad5ec58df967ddf571485c3ac14467e200af                        0.0s
 => => naming to docker.io/library/laravel-crud-app_app                                                             0.0s
[+] Running 1/0
 - Container laravel-crud-app-app-1  Running                                                                        0.0s

vemos que funciona la compilación
y se muestra pagina Laravel default en la url:
http://localhost:5000/public/

3. Al corregir el docker-compose.yml con:

    volumes:
      - ./public:/var/www/html

compila sin problema, pero obtenemos este error en url http://localhost:5000/:

Warning: require(/var/www/html/../vendor/autoload.php): Failed to open stream: No such file or directory in /var/www/html/index.php on line 34

Fatal error: Uncaught Error: Failed opening required '/var/www/html/../vendor/autoload.php' (include_path='.:/usr/local/lib/php') in /var/www/html/index.php:34 Stack trace: #0 {main} thrown in /var/www/html/index.php on line 34


4. Al eliminar el volumen de docker-compose.yml, y realizar un cambio en welcome.blade, obtenemos este error en url http://localhost:5000/public/

UnexpectedValueException
The stream or file "/var/www/html/storage/logs/laravel.log" could not be opened in append mode: Failed to open stream: Permission denied 

Puede ser un error generado por falta de permisos en los folders del sistema.


5. Al agregar comando RUN al Dockerfile:

RUN php artisan config:cache && \
    php artisan route:cache && \
    chmod 777 -R /var/www/html/storage/ && \
    chown -R www-data:www-data /var/www/ && \
    a2enmod rewrite

y al compilar con:
docker compose up -d --build

obtenemos error "Could not open input file: artisan":

=> CACHED [production 2/4] RUN docker-php-ext-install pdo pdo_mysql                                                0.0s
 => [production 3/4] COPY --from=build /app /var/www/html                                                           1.1s
 => ERROR [production 4/4] RUN php artisan config:cache &&     php artisan route:cache &&     chmod 777 -R /var/ww  0.5s
------
 > [production 4/4] RUN php artisan config:cache &&     php artisan route:cache &&     chmod 777 -R /var/www/html/storage/ &&     chown -R www-data:www-data /var/www/ &&     a2enmod rewrite:
#12 0.503 Could not open input file: artisan
------
failed to solve: rpc error: code = Unknown desc = executor failed running [/bin/sh -c php artisan config:cache &&     php artisan route:cache &&     chmod 777 -R /var/www/html/storage/ &&     chown -R www-data:www-data /var/www/ &&     a2enmod rewrite]: exit code: 1


6. Al establecer el directorio de trabajo en el Dockerfile:


RUN docker-php-ext-install pdo pdo_mysql

COPY --from=build /app /var/www/html

#setear directorio de trabajo:
WORKDIR /var/www/html


y luego al recrear el contenedor:
docker compose up -d --build

C:\desarrollo\pruebasDocker\laravel-crud-app>docker compose up -d --build
[+] Building 38.4s (15/15) FINISHED
 => [internal] load build definition from Dockerfile                                                                0.1s
 => => transferring dockerfile: 495B                                                                                0.0s
 => [internal] load .dockerignore                                                                                   0.0s
 => => transferring context: 2B                                                                                     0.0s
 => [internal] load metadata for docker.io/library/php:8.0.12-apache                                                0.0s
 => [internal] load metadata for docker.io/library/composer:2.0                                                     3.1s
 => [auth] library/composer:pull token for registry-1.docker.io                                                     0.0s
 => [internal] load build context                                                                                   4.3s
 => => transferring context: 667.81kB                                                                               4.2s
 => CACHED [build 1/3] FROM docker.io/library/composer:2.0@sha256:b3703ad1ca8e91a301c2653844633a9aa91734f3fb278c56  0.0s
 => [production 1/5] FROM docker.io/library/php:8.0.12-apache                                                       0.0s
 => [build 2/3] COPY . /app/                                                                                        1.0s
 => [build 3/3] RUN composer install                                                                                1.9s
 => CACHED [production 2/5] RUN docker-php-ext-install pdo pdo_mysql                                                0.0s
 => [production 3/5] COPY --from=build /app /var/www/html                                                           1.1s
 => [production 4/5] WORKDIR /var/www/html                                                                          0.1s
 => [production 5/5] RUN php artisan config:cache &&     php artisan route:cache &&     chmod 777 -R /var/www/htm  22.4s
 => exporting to image                                                                                              3.8s
 => => exporting layers                                                                                             3.7s
 => => writing image sha256:e645a941980219bc645f0445b449ef5a62cc216d2bcbb12e3b10be4067555623                        0.0s
 => => naming to docker.io/library/laravel-crud-app_app                                                             0.0s
[+] Running 1/1
 - Container laravel-crud-app-app-1  Started                                                                       10.5s

desaparece error de artisan


7. En este punto, obtenemos un error en http://localhost:5000/public/:

Oops! An Error Occurred
The server returned a "405 Method Not Allowed".

Something is broken. Please let us know what you were doing when this error occurred. We will fix it as soon as possible. Sorry for any inconvenience caused.


y se obtiene Not Found error en http://localhost:5000/public/students:

404
Not Found


8. Esta url sí funciona:

http://localhost:5000/public/index.php


9. Agregando puerto 8000 al Dockerfile y al docker-compose:


#abrimos puerto
EXPOSE 8000


    ports:
      - "5000:80"
      - "8000:8000"


y ejecutando php artisan serve:

root@f9af990357fd:/var/www/html# php artisan serve
Starting Laravel development server: http://127.0.0.1:8000
[Tue May 17 20:25:44 2022] PHP 8.0.12 Development Server (http://127.0.0.1:8000) started


no podemos acceder desde nuestro browser a http://localhost:8000/
Error: The connection was reset


