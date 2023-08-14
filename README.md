Описание/Пошаговая инструкция выполнения домашнего задания:
создать репозитории в GitHub (конфиги, скрипты, cron файлы и т.д.)
настроить вебсервер с балансировкой нагрузки
настроить MySQL репликацию (master-slave)
установить CMS (на выбор: jumla/wordpress/wiki...)
написать скрипт для бэкапа БД со slave сервера (потаблично с указанием позиции бинлога, скрипт хранить в GitHub)
настроить систему мониторинга (конфиги хранить в GitHub)
разработать план аварийного восстановления (на основании скриптов, конфигов, cron файлов и бэкапов в максимально короткие сроки настроить новый сервер "с нуля")
продемонстрировать аварийное восстановление (на чистом сервере за короткий промежуток времени получить полностью настроенную рабочую систему)

# server
otus_graduation_project

Для восстановления мастер сервера. 

#### На проектных лабах уже преднастроено по 8 пункт включительно.

1. Запустить и поставить в автозагрузку sshd
   systemctl enable --now sshd

2. Передать открытый и закрытый ключ ssh по протоколу sftp
   scp "C:\Users\adm\.ssh\id_ed25519.pub" root@10.77.236.182:/root/.ssh
   scp "C:\Users\adm\.ssh\id_ed25519" root@10.77.236.182:/root/.ssh
   
3. Добавить открытый ключ ssh в ключи авторизации:
   ssh root@10.77.236.182
   cat /root/.ssh/id_ed25519.pub > /root/.ssh/authorized_keys
   
4. Изменить права на закрытый ключ:
   chmod 400 ~/.ssh/id_ed25519

5. Обновление пакетов
   yum update -y   
      
6. Установить git и сконфигурировать:
   yum install -y git
   git config --global user.name "first_name last_name"
   git config --global user.email email@domain
   git config --global core.editor nano

#### Запуск скриптов для автоматической настройки и восстановления сервисов
7. Подключиться локально и узнать IP адрес полученный по dhcp

ip a

8. Перейти во временную директорию

cd /tmp
   
9. Склонировать Git репозиторий с конфигами сервера

git clone git@github.com:tsarroma/server.git

10. Поменять права и сделать исполняемыми скрипты

chmod -R 777 /tmp/server

11. Запуск скрипта с преднастройки сети, именем сервера:

Для master:
/tmp/server/pre_master.sh

Для slave:
/tmp/server/pre_slave.sh

12. Подключиться по старому ip сервера:

Для master:
ssh root@10.77.236.112

Для slave:
ssh root@10.77.236.113
    
13. Запуск скрипта установки mysql

Для master:
/tmp/server/install_mysql.sh

Для slave:
/tmp/server/install_mysql_slave.sh

14. Восстановление из бекапа:

/tmp/server/mysql_restore.sh    

15. Установка httpd, nginx с установкой wordpress   

/tmp/server/install_packet.sh

Wordpress должен быть доступен:
Nginx reverse proxy
   http://10.77.236.112/
Apache servers:   
   http://10.77.236.112:8080
   http://10.77.236.112:8081
   http://10.77.236.112:8082

16. Установка мониторинга Prometheus

/tmp/server/install_monitoring.sh

   Grafana доступна по ссылке:
   http://10.77.236.112:3000/admin
   
   Настройка:
   Меню > Administration > Data sources
   Add data source > Prometheus
   Ввести: http://localhost:9090
   Меню > Dashboards > New > Import
   Ввести ID: 1860 > Load

17. Запуск скрипта установки логирования

/tmp/server/install_logging.sh

18. Настройка репликации:
    На master:
    mysql -uroot -p
    FLUSH TABLES WITH READ LOCK;
    SHOW MASTER STATUS;

    На slave:
    Запустить скрипт и ввести данные с master сервера:
    /tmp/server/mysql_repl.sh

    На master:
    UNLOCK TABLES;
    exit
    

