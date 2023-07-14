# server
otus_graduation_project


1. Узнать IP адрес полученный по dhcp
   ip a
   
3. Запустить и поставить в автозагрузку sshd
   systemctl enable --now sshd
   
4. Передать открытый и закрытый ключ ssh по протоколу sftp
   scp "C:\Users\adm\.ssh\id_ed25519.pub" root@10.77.236.182:/root/.ssh
   scp "C:\Users\adm\.ssh\id_ed25519" root@10.77.236.182:/root/.ssh
   
5. Добавить открытый ключ ssh в ключи авторизации:
   ssh root@10.77.236.182
   cat /root/.ssh/id_ed25519.pub > /root/.ssh/authorized_keys
   
7. Изменить права на закрытый ключ:
   chmod 400 ~/.ssh/id_ed25519
      
8. Установить git
   yum install git

9. Создать директорию с конфигами
   mkdir -p -m 777 /tmp/server_config
   
10. Склонировать Git репозиторий
   git clone git@github.com:tsarroma/server.git

   
     
