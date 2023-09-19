# IaC1 день 2
Курс "Инфраструктура как код. Основные инструменты". УЦ "Специалист" 18-20.09.2023

### Рестарт DNS
```bash
nano /etc/bind/corp8.un
# Добавить $GENERATE 1-9 node$ A 192.168.8.20$

service named restart

# Проверка
host node1
host node9 # node9.corp8.un has address 192.168.8.209
```

### Vagrant
```bash
vagrant init

# Выполнится один раз
config.vm.provision "provision_once", type: "shell", inline: ...

# Выполнится каждый раз при старте машины благодаря run: "always"
config.vm.provision "provision_onstart", run: "always", type: "shell", 
```
