# server
otus_graduation_project


1. Узнать IP адрес полученный по dhcp
   ip a
2. Запустить и поставить в автозагрузку sshd
   systemctl enable --now sshd
3. Передать открытый ключ ssh по протоколу sftp
   scp "C:\Users\adm\.ssh\id_ed25519.pub" root@10.77.236.182:/root/.ssh
4. Добавить открытый ключ ssh в ключи авторизации:
   ssh root@10.77.236.182
   cat /root/.ssh/id_ed25519.pub > /root/.ssh/authorized_keys

   
     
