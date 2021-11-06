#!/bin/bash

stderr_print() {
    shopt -s nocasematch
    printf "%b\\n" "${*}" >&2
}

log() {
    stderr_print "${CYAN}${MODULE:-} ${MAGENTA}$(date "+%T.%2N ")${RESET}${*}"
}

setup() {
    cd /var/www/html 
    bin/magento setup:install --base-url="http://localhost:7071" \
            --db-host="$MYSQL_HOST" --db-name="$MYSQL_DB" --db-user="$MYSQL_USER" --db-password="$MYSQL_PASSWORD" \
            --admin-firstname="Edrone" --admin-lastname="Admin" --admin-email="admin@edrone.me" \
            --admin-user="admin" --admin-password="admin123" --language="pl_PL" \
            --currency="PLN" --timezone="Europe/Warsaw" --use-rewrites="0" \
            --search-engine="elasticsearch7" --elasticsearch-host="$ES_HOST" \
            --elasticsearch-port="9200" --session-save="redis" --cache-backend="redis" --cache-backend-redis-server="$REDIS_HOST" \
            --cache-backend-redis-db="1" --page-cache="redis" --page-cache-redis-server="$REDIS_HOST" --page-cache-redis-db="2" \
            --amqp-host="$RABBITMQ_HOST" --amqp-port="$RABBITMQ_PORT" --amqp-user="$RABBITMQ_USER" --amqp-password="$RABBITMQ_PASSWORD"
    bin/magento setup:config:set --backend-frontname="admin"
    bin/magento module:disable Magento_TwoFactorAuth
    composer require edrone/magento2module cweagans/composer-patches
    bin/magento module:enable Edrone_Magento2module
    bin/magento deploy:mode:set developer
    bin/magento setup:upgrade
    bin/magento cron:install --force
    bin/magento setup:perf:generate-fixtures /var/www/html/edrone.xml
    bin/magento c:f
    log "You can now log into admin panel on http://localhost:7071/admin or visit site on http://localhost:7071/"
    php-fpm
}

check_db() {
    log "Checking mysql host: $MYSQL_HOST"
    while ! ping -c1 $MYSQL_HOST &>/dev/null; do log "Trying connection to db ($MYSQL_HOST)"; sleep 1; done ; echo 0 
}

check_es() {
    log "Checking Elasticsearch host: $ES_HOST"
    while ! ping -c1 $ES_HOST &>/dev/null; do log "Trying connection to es ($ES_HOST)"; sleep 1; done ; echo 0 
}

check_redis() {
    log "Checking Elasticsearch host: $REDIS_HOST"
    while ! ping -c1 $REDIS_HOST &>/dev/null; do log "Trying connection to redis ($REDIS_HOST)"; sleep 1; done ; echo 0 
}

check_rabbitmq() {
    log "Checking RabbitMQ host: $RABBITMQ_HOST"
    while ! ping -c1 $RABBITMQ_HOST &>/dev/null; do log "Trying connection to rabbitmq ($RABBITMQ_HOST)"; sleep 1; done ; echo 0 
}

db_result = "$(check_db)"
es_result = "$(check_es)"
redis_result= "$(check_redis)"
amqp_result= "$(check_rabbitmq)"
if [[ $db_result -ne 0 ]] ; then
    exit -1
else
    if [[ $es_result -ne 0 ]] ; then
        exit -2
    else
        if [[ $redis_result -ne 0 ]] ; then
            exit -3
        else
            if [[ $amqp_result -ne 0 ]] ; then
                exit -4
            else
                setup
            fi
        fi
    fi
fi