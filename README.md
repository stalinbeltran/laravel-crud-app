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

