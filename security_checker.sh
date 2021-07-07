#!/bin/bash

#path where the composer.lock is
APP_DIR=/var/www/app

#path where the security-checker would be
SCRIPT_DIR=/var/www/security-checker

SCRIPT_NAME=php-security-checker

DOWNLOAD_LOCATION=https://github.com/fabpot/local-php-security-checker/releases/download/v1.0.0/
DOWNLOAD_FILE=local-php-security-checker_1.0.0_linux_amd64


composerinstall() {
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
  php composer-setup.php
  php -r "unlink('composer-setup.php');"
  mv composer.phar /usr/local/bin/composer
}

checkforcomposer() {
  composer -v > /dev/null 2>&1
  COMPOSER=$?
  if [[ $COMPOSER -ne 0 ]]; then
      composerinstall;
  fi
}

checkforcomposer;

if [ ! -d "$SCRIPT_DIR" ]; then
  mkdir -p "$SCRIPT_DIR";
fi

if [ -z "$(ls -A "$SCRIPT_DIR")" ]; then
  cd "$SCRIPT_DIR";
  #wget or curl should be installed
  wget "$DOWNLOAD_LOCATION""$DOWNLOAD_FILE" 2>/dev/null || curl -O "$DOWNLOAD_LOCATION""$DOWNLOAD_FILE";
  mv "$DOWNLOAD_FILE" "$SCRIPT_NAME";
  chmod -R 755 "$SCRIPT_DIR";
fi

cd "$SCRIPT_DIR";

"$SCRIPT_DIR"/"$SCRIPT_NAME" --path="$APP_DIR" --format=json > composererror.json;
