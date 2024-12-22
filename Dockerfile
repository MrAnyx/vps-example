FROM php:8.3.15-apache as base
WORKDIR /var/www/html
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions
RUN install-php-extensions intl
RUN install-php-extensions opcache
RUN install-php-extensions zip
RUN install-php-extensions @composer
COPY ./.docker/apache/apache.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite
CMD ["apache2-foreground"]

FROM base as dev
ENV APP_ENV=dev
RUN install-php-extensions pcov
RUN cp $PHP_INI_DIR/php.ini-development $PHP_INI_DIR/php.ini
RUN sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b  /usr/local/bin

FROM base as prod
ENV APP_ENV=prod
RUN cp $PHP_INI_DIR/php.ini-production $PHP_INI_DIR/php.ini
COPY . /var/www/html
EXPOSE 80
RUN composer install --no-dev --optimize-autoloader --no-interaction
RUN php bin/console cache:clear && php bin/console cache:warmup