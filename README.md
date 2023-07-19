# server
otus_graduation_project

Для восстановления мастер сервера. 

#### На проектных лабах уже преднастроено по 8 пункт включительно.

1. Запустить и поставить в автозагрузку sshd
   systemctl enable --now sshd
   
2. Узнать IP адрес полученный по dhcp
   ip a
    
3. Передать открытый и закрытый ключ ssh по протоколу sftp
   scp "C:\Users\adm\.ssh\id_ed25519.pub" root@10.77.236.182:/root/.ssh
   scp "C:\Users\adm\.ssh\id_ed25519" root@10.77.236.182:/root/.ssh
   
4. Добавить открытый ключ ssh в ключи авторизации:
   ssh root@10.77.236.182
   cat /root/.ssh/id_ed25519.pub > /root/.ssh/authorized_keys
   
5. Изменить права на закрытый ключ:
   chmod 400 ~/.ssh/id_ed25519

6. Обновление пакетов
   yum update -y   
      
8. Установить git и сконфигурировать:
   yum install git
   git config --global user.name "first_name last_name"
   git config --global user.email email@domain
   git config --global core.editor nano

#### Запуск скриптов для автоматической настройки и восстановления сервисов

7. Перейти во временную директорию
   cd /tmp
   
8. Склонировать Git репозиторий с конфигами сервера
   git clone git@github.com:tsarroma/server.git

9. Поменять права и сделать исполняемыми скрипты
    chmod -R 777 /tmp/server

13. Запуск скрипта преднастройки сети,

14. Запуск скрипта установки mysql
15. Запуск скрипта установки системы мониторинга
16. Запуск скрипта разворачивания системы логирования

установка wordpress
wget http://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
sudo rsync -avP ~/wordpress/ /var/www/html/
mkdir /var/www/html/wp-content/uploads
sudo chown -R apache:apache /var/www/html/*
cd /var/www/html
cp wp-config-sample.php wp-config.php

mysql -u root -pqwe123QWE!


Скачивание rpm с ftp
wget ftp://10.77.197.3/*.rpm

   
     
