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


