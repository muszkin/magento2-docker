#!/bin/bash
[ ! -d ./php/src ] && composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition ./php/src \ 
    && cp $HOME/.composer/auth.json ./php/auth.json
[ ! -f ./nginx/nginx.conf.sample ] && cp ./php/src/nginx.conf.sample nginx/nginx.conf.sample
docker-compose up -d