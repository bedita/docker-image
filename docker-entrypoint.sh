#!/bin/bash
set -e

if [ ! -f /var/www/bedita/bedita-app/config/core.php ] && [ "$1" != '/bin/bash' ]; then
    if [ -z "${BEDITA_CORE_HOST}" ]; then
        >&2 echo 'Did you forget to set the BEDITA_CORE_HOST environment variable?'
        exit 1
    fi

    while ! mysqladmin ping -h"${BEDITA_MYSQL_HOST}" --silent; do
        echo 'Waiting for MySQL server...'
        sleep 1
    done

    cd /var/www/bedita
    cp /var/www/bedita/bedita-app/config/core.php.docker /var/www/bedita/bedita-app/config/core.php
    yes | ./cake.sh bedita initDb

    for module in $BEDITA_MODULES; do
        yes | ./cake.sh module plug -name $module
    done
fi

exec "$@"
