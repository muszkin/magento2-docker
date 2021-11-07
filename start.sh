#!/bin/bash
[[ $OSTYPE != 'darwin'* ]] && sudo apt install php7.php7 4.4-common php7.4-gmp php7.4-curl php7.4-soap php7.4-bcmath php7.4-intl php7.4-mbstring php7.4-xmlrpc php7.4-mcrypt php7.4-mysql php7.4-gd php7.4-xml php7.4-cli php7.4-zip
[ ! -d ./php/src ] && composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition ./php/src
[ ! -f ./php/auth.json ] && cp $HOME/.composer/auth.json ./php
[ ! -f ./nginx/nginx.conf.sample ] && cp ./php/src/nginx.conf.sample nginx/nginx.conf.sample
docker-compose up --build
