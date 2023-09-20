# IaC1 день 2
Курс "Инфраструктура как код. Основные инструменты". УЦ "Специалист" 18-20.09.2023

### Методичка
https://wikival.bmstu.ru/doku.php

### Контейнер Debian в интерактивном режиме терминала
```bash
docker run -it --name webd --hostname webd debian bash

# Ставим сразу софт
apt update && apt install file procps nano

# Выход - CTRL+D или exit
# Присоединиться к контейнеру для внесения изменений
docker attach webd

# Сохраняем image
docker commit webd test/webd

# Проверяем
docker image ls

# Предоставление прав УЗ gitlab-runner для работы с контейнерами
usermod -aG docker gitlab-runner

# webd
https://wikival.bmstu.ru/doku.php?id=средства_программирования_shell#web_сервер_на_shell

# Сделать файл исполняемым
chmod +x webd
```

# Dockerfile
```bash
FROM debian:bullseye

RUN cp /usr/share/zoneinfo/Etc/GMT-3 /etc/localtime \
    && apt-get update \
    && apt-get install -y inetutils-inetd file \
    && apt-get clean \
    && echo 'www stream tcp nowait root /usr/local/sbin/webd webd' > /etc/inetd.conf

COPY start.sh /
COPY webd /usr/local/sbin/webd
### ADD www.tgz /var/

### for helm readiness/liveness Probe 
### COPY index.html /var/www/

EXPOSE 80
#ENV MYMODE=TEST

ENTRYPOINT ["/start.sh"]
```

# Сборка
```bash
docker build -t test/webd .

docker run --name webd01 --hostname webd01 -itd -v /var/www/:/var/www/ -p 8000:80 test/webd
```