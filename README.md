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

25. Verificamos, y sí funciona usando
php artisan serve --host 172.17.0.2

lo que indica que host.docker.internal no nos da la ip interna del contenedor


26. Cambiamos el entrypoint en Dockerfile:

#configuramos el container para que ejecute laravel en desarrollo:
ENTRYPOINT ["php", "artisan", "serve", "--host", "172.17.0.2"]

recompilamos:
docker compose up -d --build

C:\desarrollo\pruebasDocker\laravel-crud-app>docker compose up -d --build
[+] Building 10.3s (9/9) FINISHED
 => [internal] load build definition from Dockerfile                                                               0.0s
 => => transferring dockerfile: 267B                                                                               0.0s
 => [internal] load .dockerignore                                                                                  0.0s
 => => transferring context: 2B                                                                                    0.0s
 => [internal] load metadata for docker.io/library/composer:2.0                                                    2.8s
 => [auth] library/composer:pull token for registry-1.docker.io                                                    0.0s
 => [internal] load build context                                                                                  3.4s
 => => transferring context: 670.16kB                                                                              3.3s
 => CACHED [1/3] FROM docker.io/library/composer:2.0@sha256:b3703ad1ca8e91a301c2653844633a9aa91734f3fb278c56e2745  0.0s
 => [2/3] COPY . /app/                                                                                             0.9s
 => [3/3] RUN composer install                                                                                     1.7s
 => exporting to image                                                                                             1.3s
 => => exporting layers                                                                                            1.3s
 => => writing image sha256:cba11b68153365e9bed280d059a67290ed5b03663eea65e92c36f2d3f92bcbe9                       0.0s
 => => naming to docker.io/sbeltran2006/laravel-crud-app                                                           0.0s
[+] Running 1/1
 - Container laravel-crud-app-app1-1  Started                                                                      4.4s


y lo ejecutamos:
docker run -it sbeltran2006/laravel-crud-app sh

obtenemos:
 Too many arguments, expected arguments "command".

Sin embargo, funciona si usamos:
docker run -it sbeltran2006/laravel-crud-app

pero no tenemos acceso desde el browser en laptop (host)


27. Exponemos puerto 8000 en Dockerfile (puede ser la causa del problema):

#abrimos puerto 8000
EXPOSE 8000

Recompilamos:
docker compose up -d --build

y ejecutamos:
docker run -it -p 5000:8000  sbeltran2006/laravel-crud-app

y ahora sí funciona en el browser de host:
urls:
http://localhost:5000/
http://localhost:5000/students/create


28. Podemos ejecutarla en segundo plano con este comando:
docker run -d -p 5000:8000  sbeltran2006/laravel-crud-app

que es el objetivo de tener un container para desarrollo en Laravel.

29. Al cambiar el contenido de un view:

          <div class="form-group">
              @csrf
              <label for="name">Name XXX</label>
              <input type="text" class="form-control" name="name"/>
          </div>

notamos que no se actualiza. Falta lograr ese efecto, posiblemente creando un volumen


30. Modificamos Dockerfile para que no copie codigo fuente:

#COPY . /app/               no copiamos codigo fuente

y compilamos:
docker compose up -d --build

C:\desarrollo\pruebasDocker\laravel-crud-app>docker compose up -d --build
[+] Building 5.8s (6/6) FINISHED
 => [internal] load build definition from Dockerfile                                                               0.1s
 => => transferring dockerfile: 307B                                                                               0.0s
 => [internal] load .dockerignore                                                                                  0.0s
 => => transferring context: 2B                                                                                    0.0s
 => [internal] load metadata for docker.io/library/composer:2.0                                                    3.4s
 => [auth] library/composer:pull token for registry-1.docker.io                                                    0.0s
 => CACHED [1/2] FROM docker.io/library/composer:2.0@sha256:b3703ad1ca8e91a301c2653844633a9aa91734f3fb278c56e2745  0.0s
 => ERROR [2/2] RUN composer install                                                                               2.0s
------
 > [2/2] RUN composer install:
#5 1.996 Composer could not find a composer.json file in /app
#5 1.996 To initialize a project, please create a composer.json file as described in the https://getcomposer.org/ "Getting Started" section
------
failed to solve: rpc error: code = Unknown desc = executor failed running [/bin/sh -c composer install]: exit code: 1


y obtenemos el error: "Composer could not find a composer.json file in /app", probablemente por la falta del código fuente.



31. Copiamos código fuente:

#copiamos codigo fuente
COPY . /app/

compilamos:

C:\desarrollo\pruebasDocker\laravel-crud-app>docker compose up -d --build
[+] Building 3.1s (8/8) FINISHED
 => [internal] load build definition from Dockerfile                                                               0.0s
 => => transferring dockerfile: 32B                                                                                0.0s
 => [internal] load .dockerignore                                                                                  0.0s
 => => transferring context: 2B                                                                                    0.0s
 => [internal] load metadata for docker.io/library/composer:2.0                                                    1.2s
 => [internal] load build context                                                                                  1.7s
 => => transferring context: 649.58kB                                                                              1.7s
 => [1/3] FROM docker.io/library/composer:2.0@sha256:b3703ad1ca8e91a301c2653844633a9aa91734f3fb278c56e2745f589657  0.0s
 => CACHED [2/3] COPY . /app/                                                                                      0.0s
 => CACHED [3/3] RUN composer install                                                                              0.0s
 => exporting to image                                                                                             0.1s
 => => exporting layers                                                                                            0.0s
 => => writing image sha256:9216402bbd954376e3c240ad17005aa86aedb0abcde6d7d419818078dd465eaa                       0.0s
 => => naming to docker.io/sbeltran2006/laravel-crud-app                                                           0.0s
[+] Running 1/1
 - Container laravel-crud-app-app1-1  Started

pero container se apaga (no se ejecuta laravel).
Container muestra este log:

Starting Laravel development server: http://172.17.0.2:8000
[Tue Jul 19 20:03:22 2022] Failed to listen on 172.17.0.2:8000 (reason: Address not available)
Starting Laravel development server: http://172.17.0.2:8001
[Tue Jul 19 20:03:22 2022] Failed to listen on 172.17.0.2:8001 (reason: Address not available)
Starting Laravel development server: http://172.17.0.2:8002
[Tue Jul 19 20:03:23 2022] Failed to listen on 172.17.0.2:8002 (reason: Address not available)
Starting Laravel development server: http://172.17.0.2:8003
[Tue Jul 19 20:03:23 2022] Failed to listen on 172.17.0.2:8003 (reason: Address not available)
Starting Laravel development server: http://172.17.0.2:8004
[Tue Jul 19 20:03:24 2022] Failed to listen on 172.17.0.2:8004 (reason: Address not available)
Starting Laravel development server: http://172.17.0.2:8005
[Tue Jul 19 20:03:24 2022] Failed to listen on 172.17.0.2:8005 (reason: Address not available)
Starting Laravel development server: http://172.17.0.2:8006
[Tue Jul 19 20:03:25 2022] Failed to listen on 172.17.0.2:8006 (reason: Address not available)
Starting Laravel development server: http://172.17.0.2:8007
[Tue Jul 19 20:03:25 2022] Failed to listen on 172.17.0.2:8007 (reason: Address not available)
Starting Laravel development server: http://172.17.0.2:8008
[Tue Jul 19 20:03:26 2022] Failed to listen on 172.17.0.2:8008 (reason: Address not available)
Starting Laravel development server: http://172.17.0.2:8009
[Tue Jul 19 20:03:26 2022] Failed to listen on 172.17.0.2:8009 (reason: Address not available)
Starting Laravel development server: http://172.17.0.2:8010
[Tue Jul 19 20:03:27 2022] Failed to listen on 172.17.0.2:8010 (reason: Address not available)


32. Removemos volumes del Dockerfile:

     volumes:
      - .:/app/

compilamos, pero sigue sin funcionar.


33. Al remover imagen de docker-compose.yml:

#     image: sbeltran2006/laravel-crud-app

obtenemos el mismo error:

Starting Laravel development server: http://172.17.0.2:8000
[Tue Jul 19 20:03:22 2022] Failed to listen on 172.17.0.2:8000 (reason: Address not available)
Starting Laravel development server: http://172.17.0.2:8001
[Tue Jul 19 20:03:22 2022] Failed to listen on 172.17.0.2:8001 (reason: Address not available)
...

pero al revisar las imágenes, vemos que se no creó la imagen, lo que indica que al comentar el nombre sólo impedimos que se genere la imagen. Por lo tanto, volvemos a descomentar este punto en docker-compose.yml

     image: sbeltran2006/laravel-crud-app

compilammos:
docker compose up -d --build

y ahora la imagen sí se genera.



34. Al comentar el puerto abierto en Dockerfile:

# abrimos puerto 8000
# EXPOSE 8000

se sigue generando el mismo error:

Attaching to laravel-crud-app-app1-1
laravel-crud-app-app1-1 | Starting Laravel development server: http://172.17.0.2:8000
laravel-crud-app-app1-1 | [Wed Jul 20 13:13:30 2022] Failed to listen on 172.17.0.2:8000 (reason: Address not available)
laravel-crud-app-app1-1 | Starting Laravel development server: http://172.17.0.2:8001


35. Cambiar ENTRYPOINT por CMD, no resuelve el problema.

36. Al agregar ifconfig a Dockerfile:

#configuramos el container para que ejecute laravel en desarrollo:
CMD ["php", "artisan", "serve", "--host", "172.17.0.2"]
CMD ["ifconfig"]

Notamos que el problema es que la IP no es la misma que estamos especificando en el comando, lo que explica el error generado.

Attaching to laravel-crud-app-app1-1
laravel-crud-app-app1-1 | eth0      Link encap:Ethernet  HWaddr 02:42:AC:1C:00:02  
laravel-crud-app-app1-1 |           inet addr:172.28.0.2  Bcast:172.28.255.255  Mask:255.255.0.0
laravel-crud-app-app1-1 |           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
laravel-crud-app-app1-1 |           RX packets:4 errors:0 dropped:0 overruns:0 frame:0
laravel-crud-app-app1-1 |           TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
laravel-crud-app-app1-1 |           collisions:0 txqueuelen:0 
laravel-crud-app-app1-1 |           RX bytes:356 (356.0 B)  TX bytes:0 (0.0 B)
laravel-crud-app-app1-1 | 
laravel-crud-app-app1-1 | lo        Link encap:Local Loopback  
laravel-crud-app-app1-1 |           inet addr:127.0.0.1  Mask:255.0.0.0
laravel-crud-app-app1-1 |           UP LOOPBACK RUNNING  MTU:65536  Metric:1
laravel-crud-app-app1-1 |           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
laravel-crud-app-app1-1 |           TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
laravel-crud-app-app1-1 |           collisions:0 txqueuelen:1000 
laravel-crud-app-app1-1 |           RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
laravel-crud-app-app1-1 | 
laravel-crud-app-app1-1 exited with code 0


37. Al ejecutar:
docker-compose exec app1 sh
(app1 es el servicio definido en docker-compose.yml)

no aparece el container en ejecución (o desaparece tan rápido que no lo notamos)


38. Modificamos el docker-compose para que tenga una IP fija:

 version: "3.7"

 services:
   app1:
     ports:
       - 5000:8000
     build: .
     image: sbeltran2006/laravel-crud-app
     networks:
      customnetwork:
        ipv4_address: 172.20.0.10

 networks:
  customnetwork:
    ipam:
      config:
        - subnet: 172.20.0.0/16


al compilar, obtenemos este error:

C:\desarrollo\pruebasDocker\laravel-crud-app>docker compose up -d --build
[+] Building 9.6s (9/9) FINISHED
 => [internal] load build definition from Dockerfile                                                               0.0s
 => => transferring dockerfile: 32B                                                                                0.0s
 => [internal] load .dockerignore                                                                                  0.0s
 => => transferring context: 2B                                                                                    0.0s
 => [internal] load metadata for docker.io/library/composer:2.0                                                    2.6s
 => [auth] library/composer:pull token for registry-1.docker.io                                                    0.0s
 => [internal] load build context                                                                                  3.0s
 => => transferring context: 734.11kB                                                                              3.0s
 => CACHED [1/3] FROM docker.io/library/composer:2.0@sha256:b3703ad1ca8e91a301c2653844633a9aa91734f3fb278c56e2745  0.0s
 => [2/3] COPY . /app/                                                                                             1.0s
 => [3/3] RUN composer install                                                                                     1.6s
 => exporting to image                                                                                             1.3s
 => => exporting layers                                                                                            1.3s
 => => writing image sha256:6afedcafe00c1eddfe82aef67f9165615f39d387aa37011cb401542de833041b                       0.0s
 => => naming to docker.io/sbeltran2006/laravel-crud-app                                                           0.0s
[+] Running 0/0
 - Network laravel-crud-app_customnetwork  Error                                                                   0.0s
failed to create network laravel-crud-app_customnetwork: Error response from daemon: Pool overlaps with other one on this address space

Al ejecutar el comando:
docker network prune

eliminamos cualquier red previamente existente, y ahora sí funciona:

Attaching to laravel-crud-app-app1-1
laravel-crud-app-app1-1 | eth0      Link encap:Ethernet  HWaddr 02:42:AC:14:00:0A  
laravel-crud-app-app1-1 |           inet addr:172.20.0.10  Bcast:172.20.255.255  Mask:255.255.0.0
laravel-crud-app-app1-1 |           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
laravel-crud-app-app1-1 |           RX packets:2 errors:0 dropped:0 overruns:0 frame:0
laravel-crud-app-app1-1 |           TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
laravel-crud-app-app1-1 |           collisions:0 txqueuelen:0 
laravel-crud-app-app1-1 |           RX bytes:180 (180.0 B)  TX bytes:0 (0.0 B)
laravel-crud-app-app1-1 | 
laravel-crud-app-app1-1 | lo        Link encap:Local Loopback  
laravel-crud-app-app1-1 |           inet addr:127.0.0.1  Mask:255.0.0.0
laravel-crud-app-app1-1 |           UP LOOPBACK RUNNING  MTU:65536  Metric:1
laravel-crud-app-app1-1 |           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
laravel-crud-app-app1-1 |           TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
laravel-crud-app-app1-1 |           collisions:0 txqueuelen:1000 
laravel-crud-app-app1-1 |           RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
laravel-crud-app-app1-1 | 
laravel-crud-app-app1-1 exited with code 0

donde notamos que la IP (inet addr:172.20.0.10) es la deseada.


39. Al usar esta IP en Dockerfile, y eliminado el ifconfig:

#configuramos el container para que ejecute laravel en desarrollo:
CMD ["php", "artisan", "serve", "--host", "172.20.0.10"]

el container se inicia como se esperaba:

Attaching to laravel-crud-app-app1-1
laravel-crud-app-app1-1 | Starting Laravel development server: http://172.20.0.10:8000
laravel-crud-app-app1-1 | [Wed Jul 20 14:58:47 2022] PHP 8.0.6 Development Server (http://172.20.0.10:8000) started

y al exponer el puerto:

#abrimos puerto 8000
EXPOSE 8000

y compilando:
docker compose up -d --build

funcionan las urls en el browser:

http://localhost:5000
http://localhost:5000/students/create



40. Al incluir el volumen (antes eliminado) en el docker-compose:

     image: sbeltran2006/laravel-crud-app
     volumes:
      - .:/app/
     networks:

y al modificar el código en localhost, create.blade.php:

          <div class="form-group">
              @csrf
              <label for="name">Name XXX uuu</label>
              <input type="text" class="form-control" name="name"/>
          </div>

vemos que el cambio se refleja en el browser, que es lo que se desea lograr.



















41. Ahora trataremos de agregar una DB mysql a este contenedor
Al compilar, obtenemos este error:
C:\desarrollo\pruebasDocker\laravel-crud-app>docker compose up -d --build
(root) Additional property db is not allowed


42. Cambiamos nombre de database, nos conectamos a mysql mediante Heidi usando los parámetros:
DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=laravel_db
DB_USERNAME=MYSQL_USER
DB_PASSWORD=MYSQL_PASSWORD

Hallamos una db llamada MY_DATABASE, vacía. No hallamos database laravel_db (q es la que esperamos)
Tal vez fue creada al inicio, y ya no se puede cambiar.


43. Efectivamente, al destruir (remover desde Docker Desktop) el volumen db actual, y volver a construirlo, se crea la DB laravel_db y aparece en Heidi

44. Probamos a detener el container de la DB, y no se crea DB (se mantiene la original)

45. Para inicializar database ponemos un dump en la carpeta raiz del proyecto, y agregamos la siguiente línea al docker-compose:

    volumes:
      - ./laravel_db.sql:/docker-entrypoint-initdb.d/dump.sql



46. Obtenemos error debido a nombre ya empleado en una instancia en ejecución (nombre "db" era el nombre de la instancia anterior, y no fué cambiado en esta instancia con otro nombre de servicio):

En docker-compose tenemos:
   dba:
    container_name: db
    image: mysql
    restart: always

Error:

C:\desarrollo\pruebasDocker\laravel-crud-app>docker compose up -d --build
[+] Building 196.5s (10/10) FINISHED
 => [internal] load build definition from Dockerfile                                                               0.1s
 => => transferring dockerfile: 32B                                                                                0.0s
 => [internal] load .dockerignore                                                                                  0.1s
 => => transferring context: 2B                                                                                    0.0s
 => [internal] load metadata for docker.io/library/composer:2.0                                                    2.8s
 => [auth] library/composer:pull token for registry-1.docker.io                                                    0.0s
 => [internal] load build context                                                                                  6.9s
 => => transferring context: 1.12MB                                                                                6.8s
 => CACHED [1/4] FROM docker.io/library/composer:2.0@sha256:b3703ad1ca8e91a301c2653844633a9aa91734f3fb278c56e2745  0.0s
 => [2/4] COPY . /app/                                                                                             4.1s
 => [3/4] RUN composer install                                                                                     2.9s
 => [4/4] RUN docker-php-ext-install pdo pdo_mysql                                                               178.0s
 => exporting to image                                                                                             1.4s
 => => exporting layers                                                                                            1.4s
 => => writing image sha256:419d8b66d8b0ffb38e3d69b9f07f38882a760b45000717eaad85389d58932d75                       0.0s
 => => naming to docker.io/sbeltran2006/laravel-crud-app                                                           0.0s
time="2022-10-31T08:09:21-05:00" level=warning msg="Found orphan containers ([db]) for this project. If you removed or renamed this service in your compose file, you can run this command with the --remove-orphans flag to clean it up."
[+] Running 1/2
 - Container db                       Creating                                                                    12.1s
 - Container laravel-crud-app-app1-1  Recreated                                                                   12.1s
Error response from daemon: Conflict. The container name "/db" is already in use by container "048845798ad5d7935e250832a12ab52a103039c9c0eace8b2d9fe8387e03c1b7". You have to remove (or rename) that container to be able to reuse that name.


47. Al eliminar el nombre y ejecutar nuevamente, obtenemos el error: "port is already allocated":


C:\desarrollo\pruebasDocker\laravel-crud-app>docker compose up -d --build
[+] Building 100.7s (10/10) FINISHED
 => [internal] load build definition from Dockerfile                                                               0.0s
 => => transferring dockerfile: 32B                                                                                0.0s
 => [internal] load .dockerignore                                                                                  0.0s
 => => transferring context: 2B                                                                                    0.0s
 => [internal] load metadata for docker.io/library/composer:2.0                                                    2.4s
 => [auth] library/composer:pull token for registry-1.docker.io                                                    0.0s
 => [internal] load build context                                                                                  1.8s
 => => transferring context: 753.35kB                                                                              1.7s
 => CACHED [1/4] FROM docker.io/library/composer:2.0@sha256:b3703ad1ca8e91a301c2653844633a9aa91734f3fb278c56e2745  0.0s
 => [2/4] COPY . /app/                                                                                             2.7s
 => [3/4] RUN composer install                                                                                     2.3s
 => [4/4] RUN docker-php-ext-install pdo pdo_mysql                                                                89.7s
 => exporting to image                                                                                             1.5s
 => => exporting layers                                                                                            1.5s
 => => writing image sha256:aab4431825e4c69161557d618a0a571d8b3702b4c4ef1f3b2e0ceb57dcf87e5e                       0.0s
 => => naming to docker.io/sbeltran2006/laravel-crud-app                                                           0.0s
time="2022-10-31T08:31:17-05:00" level=warning msg="Found orphan containers ([db]) for this project. If you removed or renamed this service in your compose file, you can run this command with the --remove-orphans flag to clean it up."
[+] Running 1/2
 - Container laravel-crud-app-dba-1   Starting                                                                     2.3s
 - Container laravel-crud-app-app1-1  Started                                                                      2.3s
Error response from daemon: driver failed programming external connectivity on endpoint laravel-crud-app-dba-1 (45a186ce6ee8961aeda0eec663b0b46c5486f4019a0d52ecdd540296e185bf70): Bind for 0.0.0.0:9907 failed: port is already allocated

Este error se puede corregir simplemente apagando la instancia que usa ese puerto, pero decidí cambiar el puerto para evitar el conflicto, y esta vez sí funciona (alertando que quedaron containers huérfanos):


C:\desarrollo\pruebasDocker\laravel-crud-app>docker compose up -d --build
[+] Building 67.0s (10/10) FINISHED
 => [internal] load build definition from Dockerfile                                                               0.0s
 => => transferring dockerfile: 493B                                                                               0.0s
 => [internal] load .dockerignore                                                                                  0.0s
 => => transferring context: 2B                                                                                    0.0s
 => [internal] load metadata for docker.io/library/composer:2.0                                                    1.8s
 => [auth] library/composer:pull token for registry-1.docker.io                                                    0.0s
 => [internal] load build context                                                                                  1.8s
 => => transferring context: 760.73kB                                                                              1.7s
 => CACHED [1/4] FROM docker.io/library/composer:2.0@sha256:b3703ad1ca8e91a301c2653844633a9aa91734f3fb278c56e2745  0.0s
 => [2/4] COPY . /app/                                                                                             1.3s
 => [3/4] RUN composer install                                                                                     2.0s
 => [4/4] RUN docker-php-ext-install pdo pdo_mysql                                                                58.6s
 => exporting to image                                                                                             1.4s
 => => exporting layers                                                                                            1.4s
 => => writing image sha256:955f14a69a08176ceffd2497fed2d9d683717163fffedc5206575b03f4d8a744                       0.0s
 => => naming to docker.io/sbeltran2006/laravel-crud-app                                                           0.0s
time="2022-10-31T08:36:41-05:00" level=warning msg="Found orphan containers ([db]) for this project. If you removed or renamed this service in your compose file, you can run this command with the --remove-orphans flag to clean it up."
[+] Running 2/2
 - Container laravel-crud-app-dba-1   Started                                                                     13.4s
 - Container laravel-crud-app-app1-1  Started



48. Listando las redes docker, vemos que existen algunas redes, 2 de las cuales parecen estar relacionadas con esta app (laravel-crud-app_customnetwork y laravel-crud-app_default):

C:\desarrollo\pruebasDocker\laravel-crud-app>docker network ls
NETWORK ID     NAME                             DRIVER    SCOPE
f2696d544c33   bridge                           bridge    local
94241e2412ef   host                             host      local
5d6f384220ab   laravel-crud-app_customnetwork   bridge    local
c9cef8c5dd27   laravel-crud-app_default         bridge    local
8c5bb281f95a   none                             null      local

C:\desarrollo\pruebasDocker\laravel-crud-app>
C:\desarrollo\pruebasDocker\laravel-crud-app>docker network prune
WARNING! This will remove all custom networks not used by at least one container.
Are you sure you want to continue? [y/N] y

C:\desarrollo\pruebasDocker\laravel-crud-app>docker network ls
NETWORK ID     NAME                             DRIVER    SCOPE
f2696d544c33   bridge                           bridge    local
94241e2412ef   host                             host      local
5d6f384220ab   laravel-crud-app_customnetwork   bridge    local
c9cef8c5dd27   laravel-crud-app_default         bridge    local
8c5bb281f95a   none                             null      local




49. Modificamos docker-compose para que "dba" esté en la misma red que "app1":

    volumes:
      - ./laravel_db.sql:/docker-entrypoint-initdb.d/dump.sql
    networks:
      - customnetwork

y al compilar hallamos que ya no se usa una de las redes (laravel-crud-app_default):

C:\desarrollo\pruebasDocker\laravel-crud-app>docker compose up -d --build
[+] Building 99.7s (10/10) FINISHED
 => [internal] load build definition from Dockerfile                                                               0.1s
 => => transferring dockerfile: 32B                                                                                0.0s
 => [internal] load .dockerignore                                                                                  0.0s
 => => transferring context: 2B                                                                                    0.0s
 => [internal] load metadata for docker.io/library/composer:2.0                                                    5.2s
 => [auth] library/composer:pull token for registry-1.docker.io                                                    0.0s
 => [internal] load build context                                                                                  2.3s
 => => transferring context: 1.27MB                                                                                2.2s
 => CACHED [1/4] FROM docker.io/library/composer:2.0@sha256:b3703ad1ca8e91a301c2653844633a9aa91734f3fb278c56e2745  0.0s
 => [2/4] COPY . /app/                                                                                             4.3s
 => [3/4] RUN composer install                                                                                     3.0s
 => [4/4] RUN docker-php-ext-install pdo pdo_mysql                                                                83.4s
 => exporting to image                                                                                             1.4s
 => => exporting layers                                                                                            1.3s
 => => writing image sha256:2dfa6a5d8042bbec88cab319f2a5d2b9eb63e58be613ddcef3d667aa29e8a000                       0.0s
 => => naming to docker.io/sbeltran2006/laravel-crud-app                                                           0.0s
[+] Running 2/2
 - Container laravel-crud-app-dba-1   Started                                                                     13.9s
 - Container laravel-crud-app-app1-1  Started                                                                     13.8s

C:\desarrollo\pruebasDocker\laravel-crud-app>
C:\desarrollo\pruebasDocker\laravel-crud-app>
C:\desarrollo\pruebasDocker\laravel-crud-app>docker network prune
WARNING! This will remove all custom networks not used by at least one container.
Are you sure you want to continue? [y/N] y
Deleted Networks:
laravel-crud-app_default


C:\desarrollo\pruebasDocker\laravel-crud-app>docker network ls
NETWORK ID     NAME                             DRIVER    SCOPE
f2696d544c33   bridge                           bridge    local
94241e2412ef   host                             host      local
5d6f384220ab   laravel-crud-app_customnetwork   bridge    local
8c5bb281f95a   none                             null      local

Sin embargo, el error en el browser sigue siendo el mismo:

Illuminate\Database\QueryException
SQLSTATE[HY000] [2002] php_network_getaddresses: getaddrinfo failed: Try again (SQL: select * from `students`) 



50. Al cambiar nombre del servicio, 

   db:
    image: mysql
    restart: always

y recompilando, obtenemos el error: "port is already allocated":

 If you removed or renamed this service in your compose file, you can run this command with the --remove-orphans flag to clean it up."
[+] Running 1/2
 - Container laravel-crud-app-db-1    Starting                                                                    12.9s
 - Container laravel-crud-app-app1-1  Started                                                                     12.9s
Error response from daemon: driver failed programming external connectivity on endpoint laravel-crud-app-db-1 (c77cf38d0be57137455678756d31fd810a57f2aee25c4c16258670d4f110cf5a): Bind for 0.0.0.0:9906 failed: port is already allocated


Al remover el contenedor anterior que genera el conflicto, obtenemos:
                                                                                          1.3s
 => => exporting layers                                                                                            1.3s
 => => writing image sha256:43bc5c160bd10874bc6299a3171a4280a5a89a0f959b0158c202c83971653bb4                       0.0s
 => => naming to docker.io/sbeltran2006/laravel-crud-app                                                           0.0s
[+] Running 2/2
 - Container laravel-crud-app-db-1    Started                                                                     16.3s
 - Container laravel-crud-app-app1-1  Started                                                                     16.3s



y al fin obtenemos acceso a la data en la DB, en el url http://localhost:5000/students/
(vemos listado el único estudiante de la DB)


