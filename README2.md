# IaC1 день 2
Курс "Инфраструктура как код. Основные инструменты". УЦ "Специалист" 18-20.09.2023

### Методичка
https://wikival.bmstu.ru/doku.php

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

### Проверка скриптов shell
```bash
apt install shellcheck
```

### Ansible
```bash
# Парольная аутентификация
apt install sshpass

# Не проверять ключи SSH
nano /etc/ansible/ansible.cfg
# Добавляем в секцию defaults
# host_key_checking = False

# Установка openvpn через Ansible в 3 потока (-f 3)
ansible nodes -f 3 -m apt -a 'pkg=openvpn state=present update_cache=true'
```

### Ansible при исполнении любого playbook запускает модуль setup, в котором мы можем получить все параметры машины
```bash
ansible -m setup node1 | tee t.txt
```

### Файл инвентаризации в виде yaml
```yml
all:
  vars:
    X: "{{ ansible_eth1.ipv4.address.split('.')[2] }}"
    ansible_python_interpreter: "/usr/bin/python3"
    ansible_ssh_user: vagrant
    ansible_ssh_pass: strongpassword
    ansible_become: yes
    node_nets:
      node1: 192.168.110.0
      node2: 192.168.120.0
      node3: 192.168.130.0

prod_nodes:
  hosts:
    node1:
    node2:

test_nodes:
  hosts:
    node3:
```

### Примеры ролей из курса
```bash
wget https://val.bmstu.ru/unix/conf.git/conf/ansible/roles/openvpn1.tgz && tar -xvzf openvpn1.tgz && cd openvpn1
```

### GitLab
```bash
# Default пароль от УЗ root лежит в /etc/gitlab/initial_root_password
# Или сброс пароля командой
sudo gitlab-rake "gitlab:password:reset"
```

### keepalived - балансировщик
```bash
apt install keepalived
systemctl enable keepalived
systemctl start keepalived
```

### Описание CI/CD/CDP
https://solanteq.ru/blog/ci-cd-или-как-ускорить-сборку-кода-и-сэконо/