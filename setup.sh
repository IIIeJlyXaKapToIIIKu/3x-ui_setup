#!/bin/bash

# Обновляем списки пакетов
apt update

# Обновляем установленные пакеты
apt full-upgrade -y

# Устанавливаем необходимые пакеты
apt install docker.io docker-compose git curl bash openssl nano speedtest-cli -y

# Запускаем тест скорости дважды
speedtest
speedtest

# Клонируем репозиторий
git clone https://github.com/MHSanaei/3x-ui.git

# Переходим в директорию репозитория
cd 3x-ui

# Делаем резервную копию оригинального docker-compose.yml
cp docker-compose.yml docker-compose.yml.bak

# Заменяем "latest" на "v2.4.6" в docker-compose.yml
sed -i 's/:latest/:v2.4.6/' docker-compose.yml

# Запускаем контейнеры Docker
docker-compose up -d

# Генерируем самоподписанный TLS-сертификат
openssl req -x509 -newkey rsa:4096 -nodes -sha256 -keyout private.key -out public.key -days 3650 -subj "/CN=APP"

# Получаем ID запущенного контейнера
container_id=$(docker-compose ps -q)

if [ -z "$container_id" ]; then
    echo "Ошибка: не удалось найти запущенный контейнер для сервиса 3x-ui."
    exit 1
fi

# Копируем ключи в контейнер
docker cp private.key 3x-ui:private.key
docker cp public.key 3x-ui:public.key
