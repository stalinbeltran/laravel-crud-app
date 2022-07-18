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


10. Al ejecutar el proyecto localmente con:
php artisan serve

hallamos estos errores:}
SQLSTATE[HY000] [1045] Access denied for user 'sail'@'localhost' (using password: YES) (SQL: select * from `students`) :
http://localhost:8000/public/students

not found:
http://localhost:8000/public/



11. Creamos una DB vacia (en este caso con nombre 'laravel_db'), y la configuramos en el .env.
Luego al ejecutar el comando:
php artisan migrate

se crean varias tablas en la DB.
Ahora sí funcionan los links:
http://localhost:8000/public/students
http://localhost:8000/public/students/create


12. Instalamos laravel sail:
composer require laravel/sail --dev

C:\desarrollo\pruebasDocker\laravel-crud-app>composer require laravel/sail --dev
Info from https://repo.packagist.org: #StandWithUkraine
Using version ^1.15 for laravel/sail
./composer.json has been updated
Running composer update laravel/sail
Loading composer repositories with package information
Info from https://repo.packagist.org: #StandWithUkraine
Updating dependencies
Lock file operations: 1 install, 0 updates, 0 removals
  - Locking laravel/sail (v1.15.0)
Writing lock file
Installing dependencies from lock file (including require-dev)
Package operations: 0 installs, 1 update, 0 removals
  - Downloading laravel/sail (v1.15.0)
  - Upgrading laravel/sail (v1.14.4 => v1.15.0): Extracting archive
Generating optimized autoload files
> Illuminate\Foundation\ComposerScripts::postAutoloadDump
> @php artisan package:discover --ansi
Discovered Package: facade/ignition
Discovered Package: fideloper/proxy
Discovered Package: fruitcake/laravel-cors
Discovered Package: laravel/sail
Discovered Package: laravel/tinker
Discovered Package: nesbot/carbon
Discovered Package: nunomaduro/collision
Package manifest generated successfully.
72 packages you are using are looking for funding.
Use the `composer fund` command to find out more!


13. Ejecutamos comando:
php artisan sail:install

C:\desarrollo\pruebasDocker\laravel-crud-app>php artisan sail:install

 Which services would you like to install? [mysql]:
  [0] mysql
  [1] pgsql
  [2] mariadb
  [3] redis
  [4] memcached
  [5] meilisearch
  [6] minio
  [7] mailhog
  [8] selenium
 > 0

Sail scaffolding installed successfully.

14. Al ejecutar comando:
COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1 ./vendor/bin/sail build

obtenemos un error (Laravel Sail no está hecho para windows sin WSL usar)
C:\desarrollo\pruebasDocker\laravel-crud-app>COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1 ./vendor/bin/sail build
"COMPOSE_DOCKER_CLI_BUILD" no se reconoce como un comando interno o externo,
programa o archivo por lotes ejecutable.

Esto dificulta considerablemente la implementación de Sail para este proyecto (usar WSL no es una opción atractiva en este momento)
La alternativa es crear manualmente un contenedor que realice las mismas funciones.













15. Empezamos la implementacion manual de entorno de desarrollo laravel. Avanzaremos paso a paso para entender lo que se está haciendo.
Primero reducimos Dockerfile a lo sgte:

FROM composer:2.0 as build
COPY . /app/
RUN composer install

Luego compilamos la imagen con nombre 'laravel-crud-app'

docker build -t sbeltran2006/laravel-crud-app .

C:\desarrollo\pruebasDocker\laravel-crud-app>docker build -t sbeltran2006/laravel-crud-app .
[+] Building 16.2s (9/9) FINISHED
 => [internal] load build definition from Dockerfile                                                               0.1s
 => => transferring dockerfile: 98B                                                                                0.0s
 => [internal] load .dockerignore                                                                                  0.0s
 => => transferring context: 2B                                                                                    0.0s
 => [internal] load metadata for docker.io/library/composer:2.0                                                    3.7s
 => [auth] library/composer:pull token for registry-1.docker.io                                                    0.0s
 => [internal] load build context                                                                                  6.5s
 => => transferring context: 36.56MB                                                                               6.4s
 => CACHED [1/3] FROM docker.io/library/composer:2.0@sha256:b3703ad1ca8e91a301c2653844633a9aa91734f3fb278c56e2745  0.0s
 => [2/3] COPY . /app/                                                                                             1.9s
 => [3/3] RUN composer install                                                                                     2.5s
 => exporting to image                                                                                             1.4s
 => => exporting layers                                                                                            1.4s
 => => writing image sha256:8eec97aef90ffadb62ba113248380a253bbad217949574d72b846ad26403d0d8                       0.0s
 => => naming to docker.io/sbeltran2006/laravel-crud-app                                                           0.0s



16. Revisamos el contenido de la imagen:
docker run -it sbeltran2006/laravel-crud-app sh

C:\desarrollo\pruebasDocker\laravel-crud-app>docker run -it sbeltran2006/laravel-crud-app sh
/app # ls
Dockerfile  artisan        composer.lock  docker-compose.yml  public     server.php  vendor
README.md   bootstrap      config         package.json        resources  storage     webpack.mix.js
app         composer.json  database       phpunit.xml         routes     tests


Notamos que se han copiado los archivos del proyecto, como se espera por la instrucción en Dockerfile:

COPY . /app/



17. Probamos a ejecutar el proyecto:
php artisan serve

/app # php artisan serve
Starting Laravel development server: http://127.0.0.1:8000
[Mon Jul 11 20:32:36 2022] PHP 8.0.6 Development Server (http://127.0.0.1:8000) started


pero no podemos ejecutar la aplicación en el browser porque no tenemos un puerto abierto


18. Abrimos un puerto en Dockerfile:

#abrimos puerto 8000
EXPOSE 8000


19. Mapeamos puerto 5000 en localhost a 8000 container en archivo docker-compose.yml:

 version: "3.7"

 services:
   app1:
     ports:
       - 5000:8000


20. Para verificar, compilammos proyecto con docker compose:
docker compose up -d --build


C:\desarrollo\pruebasDocker\laravel-crud-app>docker compose up -d --build
[+] Building 11.7s (9/9) FINISHED
 => [internal] load build definition from Dockerfile                                                               0.0s
 => => transferring dockerfile: 132B                                                                               0.0s
 => [internal] load .dockerignore                                                                                  0.0s
 => => transferring context: 2B                                                                                    0.0s
 => [internal] load metadata for docker.io/library/composer:2.0                                                    2.6s
 => [auth] library/composer:pull token for registry-1.docker.io                                                    0.0s
 => [internal] load build context                                                                                  3.4s
 => => transferring context: 36.58MB                                                                               3.4s
 => CACHED [1/3] FROM docker.io/library/composer:2.0@sha256:b3703ad1ca8e91a301c2653844633a9aa91734f3fb278c56e2745  0.0s
 => [2/3] COPY . /app/                                                                                             1.8s
 => [3/3] RUN composer install                                                                                     2.4s
 => exporting to image                                                                                             1.3s
 => => exporting layers                                                                                            1.3s
 => => writing image sha256:cde5904a2bd80921ac44b72b1b175e3c5ef4890f92701e56930ad5472805b405                       0.0s
 => => naming to docker.io/sbeltran2006/laravel-crud-app                                                           0.0s
[+] Running 1/1
 - Container laravel-crud-app-app1-1  Started                                                                      1.8s


Pero vemos que el container salió, nunca se ejecutó. Tal vez falta una aplicación que se ejecute todo el tiempo, para que no se termine la ejecución del container.


21. Probamos agregar un ENTRYPOINT al Dockerfile:

ENTRYPOINT ["php", "artisan", "serve"]

y compilamos:
docker compose up -d --build

El contenedor se mantiene en ejecución, pero no es accesible desde localhost.


22. Haciendo pruebas e investigando, hallé que el problema está en el comando laravel:

php artisan serve
que debería agregar el parámetro host:
php artisan serve --host 172.17.0.2

y al hacerlo así, funcionan estas páginas:

http://localhost:5000                   #muestra index laravel default
http://localhost:5000/students/create   #muestra crear estudiante


El problema con esta opción es que tenemos q conocer la IP del container, y la obtuvimos manualmente.


23. Probamos a usar la ip localhost:

php artisan serve --host 127.0.0.1

pero no funciona. No obtenemos ninguna respuesta desde el host.


24. Probamos a usar "host.docker.internal" para obtener IP interna del container:
docker run -it -p 5000:8000  sbeltran2006/laravel-crud-app sh
php artisan serve --host host.docker.internal

pero falla porque la dirección no está disponible

C:\desarrollo\pruebasDocker\laravel-crud-app>docker run -it -p 5000:8000  sbeltran2006/laravel-crud-app sh
/app # php artisan serve --host host.docker.internal
Starting Laravel development server: http://host.docker.internal:8000
[Mon Jul 18 13:06:44 2022] Failed to listen on host.docker.internal:8000 (reason: Address not available)
Starting Laravel development server: http://host.docker.internal:8001
[Mon Jul 18 13:06:44 2022] Failed to listen on host.docker.internal:8001 (reason: Address not available)
Starting Laravel development server: http://host.docker.internal:8002
[Mon Jul 18 13:06:45 2022] Failed to listen on host.docker.internal:8002 (reason: Address not available)
Starting Laravel development server: http://host.docker.internal:8003
[Mon Jul 18 13:06:45 2022] Failed to listen on host.docker.internal:8003 (reason: Address not available)
Starting Laravel development server: http://host.docker.internal:8004
[Mon Jul 18 13:06:46 2022] Failed to listen on host.docker.internal:8004 (reason: Address not available)
Starting Laravel development server: http://host.docker.internal:8005
[Mon Jul 18 13:06:46 2022] Failed to listen on host.docker.internal:8005 (reason: Address not available)
Starting Laravel development server: http://host.docker.internal:8006
[Mon Jul 18 13:06:47 2022] Failed to listen on host.docker.internal:8006 (reason: Address not available)
Starting Laravel development server: http://host.docker.internal:8007
[Mon Jul 18 13:06:47 2022] Failed to listen on host.docker.internal:8007 (reason: Address not available)
Starting Laravel development server: http://host.docker.internal:8008
[Mon Jul 18 13:06:48 2022] Failed to listen on host.docker.internal:8008 (reason: Address not available)
Starting Laravel development server: http://host.docker.internal:8009
[Mon Jul 18 13:06:48 2022] Failed to listen on host.docker.internal:8009 (reason: Address not available)
Starting Laravel development server: http://host.docker.internal:8010
[Mon Jul 18 13:06:49 2022] Failed to listen on host.docker.internal:8010 (reason: Address not available)
/app #

