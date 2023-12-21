# Docker Wordpress

Сборка для работы с wordpress в docker

## Wordpress + MySQL
```yaml
services:
  db:
    image: mysql:8.0.27
    command: '--default-authentication-plugin=mysql_native_password'
    volumes:
      - ./wp-db:/var/lib/mysql
    restart: always
    environment:
      - MYSQL_ROOT_PASSWORD=somewordpress
      - MYSQL_DATABASE=wordpress
      - MYSQL_USER=wordpress
      - MYSQL_PASSWORD=wordpress
    expose:
      - 3306
      - 33060
  wordpress:
    # use wp-xdebug for wp with xdebug
    image: wordpress:latest
    ports:
      - 80:80
    volumes:
#      - .:/var/www/html/wp-content/themes/{your_theme}
#      - ./.htaccess:/var/www/html/.htaccess
      - ./wp-html:/var/www/html
    restart: always
    environment:
      - WORDPRESS_DB_HOST=db
      - WORDPRESS_DB_USER=wordpress
      - WORDPRESS_DB_PASSWORD=wordpress
      - WORDPRESS_DB_NAME=wordpress
# use volume
```
> Note: Можно использовать общие volume для ядра в нескольких проектах.

### Текущая структура подразумевает, что корень репозитория = {ваша_тема}
```yaml
#      - .:/var/www/html/wp-content/themes/{your_theme}
```

### .htaccess для редиректа папки upload на боевой сайт (если разворачивается копия для разработки)
```text
<IfModule mod_rewrite.c>
Options +FollowSymLinks -MultiViews
RewriteRule ^wp-content/uploads/(.+) https://{production_domen}.ru%{REQUEST_URI} [L,QSA,NC]
</IfModule>
```
### XDebug
```yaml
  wordpress:
    # image: wordpress
    build:
      context: .
      dockerfile: wp-xdegug.Dockerfile
    ports:
    ...
```

## Frontend
```yaml
  frontend:
    build:
      context: .
      dockerfile: frontend.Dockerfile
    ports:
      - 3000:3000
      - 3001:3001
    volumes:
      - ./:/app
      - /app/node_modules
    stdin_open: true
    tty: true
```
> CMD ["npm", "run", "watch"] используйте свои команды для сборки в контейнере