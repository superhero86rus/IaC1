# IaC1 день 3
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

# Если нужен рандомный порт, тогда ключ -P
```

### Docker Compose поднимет 3 контейнера
```bash
version: "3"
services:
  webd:
    image: server.corp8.un:5000/student/webd:1.1
    ports:
      - "80"
    volumes:
      - /var/www/:/var/www/
    deploy:
      mode: replicated
      replicas: 3
```

### Kubernetes
```bash

# Скачивание minikube
apt install -y curl wget apt-transport-https
wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
mv minikube-linux-amd64 /usr/local/bin/minikube
chmod +x /usr/local/bin/minikube

# Установка от неприлигированного пользователя (gitlab-runner)
time minikube start --driver=docker --insecure-registry "server.corp8.un:5000"

# ALIAS kubectl чтобы было единообразие k8s и minikube
alias kubectl='minikube kubectl --'
```

#### Replica Set - ревностно наблюдает чтобы кол-во подов было заявленным. При падении любого пода - новый автоматически поднимется

#### Service - про то, как воспользоваться нашим приложением? Указываем порты и метки подов в yaml-конфигурации

### NGINX
```bash
    # Проксируем адрес webd.corp8.un в наш куб-кластер
    server {
        listen 80;
        server_name webd.corp8.un;

        location / {
            proxy_pass http://192.168.49.2:30111/;
        }
    }
    server {
        listen 80;
        server_name mail.corp8.un;

        location / {
            proxy_pass http://server.corp8.un:81/mail/;
        }
    }
    server {
        listen 80;
        server_name corp8.un www.corp8.un;

        location / {
            proxy_pass http://server.corp8.un:81/;
        }
    }
```

### Terraform можно настроить для локального Virtual Box
### HashiCorp Packer - сборка образов для Vagrant Cloud
### Vegeta - приложение для подачи нагрузки для тестирования балансировки
### Helm - шаблонизатор для Kubernetes

### Werf - deploy в Kubernetes от Flant
https://tproger.ru/articles/kubernetes-node-js-werf