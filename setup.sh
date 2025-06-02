#!/usr/bin/bash

apt update

apt full-upgrade -y

apt install docker.io docker-compose git curl bash openssl nano speedtest-cli -y

speedtest
speedtest

git clone https://github.com/MHSanaei/3x-ui.git

cd 3x-ui

cp docker-compose.yml docker-compose.yml.bak

sed -i 's/:latest/:v2.6.0/' docker-compose.yml

docker-compose up -d

openssl req -x509 -newkey rsa:4096 -nodes -sha256 -keyout private.key -out public.key -days 3650 -subj "/CN=APP"

container_id=$(docker-compose ps -q)

if [ -z "$container_id" ]; then
    echo "Ошибка: не удалось найти запущенный контейнер для сервиса 3x-ui."
    exit 1
fi

docker cp private.key 3x-ui:private.key
docker cp public.key 3x-ui:public.key
