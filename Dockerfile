FROM php:8.1-fpm-alpine3.17

RUN docker-php-ext-install opcache pdo pdo_mysql mysqli

RUN apk update && apk upgrade && \
    apk add nginx

COPY --from=composer:2.2.7 /usr/bin/composer /usr/bin/composer

WORKDIR /app

COPY . .

COPY ./docker/etc/nginx.conf /etc/nginx/http.d/default.conf

RUN composer install

COPY .env.docker-prod.local .env.local

EXPOSE 80

RUN chmod +x ./docker/docker_wrapper_script.sh

CMD ["./docker/docker_wrapper_script.sh"]
