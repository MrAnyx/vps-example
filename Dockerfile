FROM php:8.3.15-fpm as base
WORKDIR /var/www/html
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions
RUN install-php-extensions intl
RUN install-php-extensions opcache
RUN install-php-extensions zip
RUN install-php-extensions @composer

FROM base as dev
RUN install-php-extensions pcov
RUN cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini

FROM base as prod
RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini
COPY . .
RUN APP_ENV=prod composer install --no-dev --optimize-autoloader --no-interaction