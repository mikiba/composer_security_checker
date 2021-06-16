#!/bin/bash

#path where the composer.lock is
APP_DIR=/var/www/app

#path where the security-checker would be
SCRIPT_DIR=/var/www/security-checker

SCRIPT_NAME=php-security-checker

DOWNLOAD_LOCATION=https://github.com/fabpot/local-php-security-checker/releases/download/v1.0.0/
DOWNLOAD_FILE=local-php-security-checker_1.0.0_linux_amd64


if [ ! -d "$SCRIPT_DIR" ]; then
  mkdir -p "$SCRIPT_DIR";
fi

if [ -z "$(ls -A "$SCRIPT_DIR")" ]; then
  cd "$SCRIPT_DIR";
  wget "$DOWNLOAD_LOCATION""$DOWNLOAD_FILE";
  mv "$DOWNLOAD_FILE" "$SCRIPT_NAME";
  chmod -R 755 "$SCRIPT_DIR";
fi

cd "$SCRIPT_DIR";

"$SCRIPT_DIR"/"$SCRIPT_NAME" --path="$APP_DIR";
