FROM dunglas/frankenphp:php8.3.15 as base
WORKDIR /app
RUN install-php-extensions intl
RUN install-php-extensions opcache
RUN install-php-extensions zip
RUN install-php-extensions @composer

FROM base as dev
RUN install-php-extensions pcov
RUN cp $PHP_INI_DIR/php.ini-development $PHP_INI_DIR/php.ini
RUN sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b  /usr/local/bin

FROM base as prod
RUN cp $PHP_INI_DIR/php.ini-production $PHP_INI_DIR/php.ini
COPY . .
RUN APP_ENV=prod composer install --no-dev --optimize-autoloader --no-interaction