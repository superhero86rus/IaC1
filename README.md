# IaC1
Курс "Инфраструктура как код. Основные инструменты". УЦ "Специалист" 18-20.09.2023

### Эмулятор консоли Cmder
https://cmder.app/

### Логин/Пароль для машины №8 в Специалисте
Administrator/Pa$$w0rd#11

### УЗ для виртуальных машин
root/Pa$$w0rd

### Методичка
https://wikival.bmstu.ru/doku.php

https://wikival.bmstu.ru/doku.php?id=devops1._основные_инструменты

### Репозиторий с конфигами для виртуальных машин
```bash
test -d conf && rm -r conf
git clone http://val.bmstu.ru/unix/conf.git
cd conf/virtualbox/
# X - номер рабочего места, в нашем случае X = 8
./setup.sh X 8
```

### Заходим на gate (192.168.8.1) по SSH
```bash
sh net_gate.sh
sh conf/dns.sh
nano /etc/resolv.conf
# раскомментируем nameserver 192.168.X.10 и комментируем другие ip
# проверяем связь
nslookup ns
```

### Заходим на server (192.168.8.10) по SSH
```bash
sh net_server.sh
sh conf/dns.sh
nano /etc/resolv.conf
# раскомментируем nameserver 192.168.X.10 и комментируем другие ip
# проверяем связь
nslookup ns
```

### Добавляем ENV окружения
```bash
nano .bashrc

# добавляем
export http_proxy=http://proxy.isp.un:3128/
export https_proxy=http://proxy.isp.un:3128/
export no_proxy=localhost,127.0.0.1,isp.un,corpX.un
```

### Установка gitea на сервере
```bash
snap istall gitea

# Открываем в браузере http://server.corp8.un:3000
```

### Установка JRE (для Jenkins)
```bash
apt install default-jre-headless # need for openfire, vtigercrm
apt install openjdk-11-jre # need for spark
```

### Установка Jenkins
```bash
# Берем ключ
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
# Добавить ссылку на репозиторий jenkins
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
# Установка
sudo apt-get update
sudo apt-get install jenkins

# Конфликт портов в GitLab решаем так:
systemctl stop jenkins
systemctl edit jenkins

# Добавляем в файл
[Service]
Environment="JENKINS_PORT=8081"

# Запускаем
systemctl start jenkins
# Проверяем статус
systemctl status jenkins | grep Active:
# Открываем http://server.corp8.un:8081/
# Берем пароль в /var/lib/jenkins/secrets/initialAdminPassword и логинимся
# 6d7c4afd6ee842109a8c6a48e24c9f57

# Устанавливаем агент на gate
useradd -m -s /bin/bash jenkins
# Добавляем привилегий агенту через visudo
# jenkins       ALL=NOPASSWD: /usr/bin/make install
su - jenkins
# Скачиваем и устанавливаем агент
curl -sO http://server.corp8.un:8081/jnlpJars/agent.jar
java -jar agent.jar -jnlpUrl http://server.corp8.un:8081/computer/gate/jenkins-agent.jnlp -secret 5a8e5f106008e26ee59bd70a0765aaf8dc6c36b67eecd936445284230e89bef6 -workDir "/home/jenkins"
```

### Хорошая практика - положить /etc под Git чтобы контролировать конфиги

### Конфигурация dhcp на gate
```bash
sh conf/dhcp.sh
```

### Как запустить команду в фоне (BG)
```bash
ping localhost &

#выход командой fg
fg
```

### Установка GitLab
```bash
apt-get install -y curl ca-certificates perl
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | bash
time EXTERNAL_URL="http://server.corp8.un" apt-get install gitlab-ce
```

### Ставим программу анализа dhcp
```bash
apt install dhcpd-pools
# Запускаем в режиме опроса
watch dhcpd-pools
```
