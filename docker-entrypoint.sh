#!/bin/bash
set -e

export BEDITA_CORE_LOGS="/var/www/bedita/bedita-app/tmp/logs"
export BEDITA_FRONTEND_LOGS="/var/www/bedita/frontends/bootstrap/tmp/logs"

# Truncate log files.
truncate -s0 $BEDITA_CORE_LOGS/{cleanup,debug,error,exception,warn}.log
truncate -s0 $BEDITA_FRONTEND_LOGS/{cleanup,debug,error,exception,warn}.log

# Set permissions
chmod -R 777 /var/www/bedita/bedita-app/tmp
chmod -R 777 /var/www/bedita/bedita-app/webroot/files
chmod -R 777 /var/www/bedita/frontends/bootstrap/tmp

if [ "$1" != 'bash' ] && [ "$1" != '/bin/bash' ]; then
    # Chech that all required variables are set.
    requiredVars="BEDITA_CORE_HOST BEDITA_MYSQL_HOST BEDITA_MYSQL_NAME BEDITA_MYSQL_USER BEDITA_MYSQL_PASS"
    for requiredVar in $requiredVars; do
        if [ -z "${!requiredVar}" ]; then
            echo >&2 "Did you forget to set the ${requiredVar} environment variable?"
            exit 1
        fi
    done

    # Check if container has just been created.
    if [ ! -f /var/www/bedita/bedita-app/config/core.php ]; then
        # Wait for MySQL server to be up.
        ATTEMPTS=30
        for i in {30..0}; do
            if mysqladmin ping -h"${BEDITA_MYSQL_HOST}" --silent; then
                break
            fi
            echo 'Waiting for MySQL server...'
            sleep 1
        done
        if [ "$i" = 0 ]; then
            echo >&2 'MySQL server unavailable!'
            exit 1
        fi

        # Copy configuration files.
        cd /var/www/bedita
        cp /var/www/bedita/bedita-app/config/core.php.docker /var/www/bedita/bedita-app/config/core.php

        # Initialize DB.
        yes | ./cake.sh bedita initDb

        # Plug-in modules.
        for module in $BEDITA_MODULES; do
            yes | ./cake.sh module plug -name $module
        done
    fi
fi

exec "$@"
