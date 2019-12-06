This docker image provides a Minecraft Plug-in Server that will automatically download the PAPER(spigot fork) selectable version at startup.
Japanese localization.

# To simply use the latest stable version, run
docker run -d -p 25565:25565 -p 80:80 -v /host/directory/servers:/opt/minecraft -v /host/directory/admin:/var/www/html --name jve ccmite/jve


# Example Docker Compose app

* docker-compose.yml

<pre>
version: '2'
services:
# C.C.mite Server ###################################################
  jve:
    image: ccmite/jve:latest
    container_name: jve
    hostname: jve
    tty: true
    restart: always
    ports:
      - '0.0.0.0:25565:25565'
      - '0.0.0.0:25575:25575'
      - '0.0.0.0:25555:22'
      - '0.0.0.0:8443:80'
      - '0.0.0.0:8123:8123'
      - '0.0.0.0:8192:8192'
    volumes:
      - '/host/directory/servers:/opt/minecraft'
      - '/host/directory/admin:/var/www/html'
      - '/host/directory/map:/opt/minecraft/ccmite/plugins/dynmap/web'
    environment:
      MC_INSTANCE_NAME: paper
      MC_VERSION: 1.14.4
      MC_PAPER_BUILD: 226
      MC_RAM: 2G
      MC_CPU_CORE: 1
      LANG: ja-JP.UTF-8
    mem_limit: 3g
    depends_on:
      - cpr
# CoreProtect DB Server ##############################################
  cpr:
    image: ccmite/db:latest
    container_name: cpr
    hostname: cpr
    tty: true
    restart: always
    ports:
      - '0.0.0.0:3307:3306'
    volumes:
      - '/host/directory/coreprotectdb:/var/lib/mysql'
    environment:
      MARIADB_ROOT_PASSWORD: SecretPassword
      MARIADB_DATABASE: coreprotect
      MARIADB_INITDB_SKIP_TZINFO: "true"
      LANG: ja-JP.UTF-8
    mem_limit: 256m
# Restart and Cloud Backup Server ###################################################
  bks:
    image: ccmite/bks:latest
    container_name: bks
    hostname: bks
    tty: true
    restart: always
   
    volumes:
      - '/host/directory/servers:/opt/minecraft'
      - '/host/directory/bkup:/var/spool/cron'
      - '/var/run/docker.sock:/var/run/docker.sock'
    environment:
      LANG: ja-JP.UTF-8
      MC_SRVIP: 192.168.0.100
      MC_SSH: /usr/bin/ssh
      MC_SSHPORT: 25555
      MC_USER: root
      MC_RCON: /usr/bin/mcrcon
      MC_RCONPORT: 25575
      MC_RCONPASS: SecretPassword
    mem_limit: 128m
</pre>


# Example WebConsole

* https://github.com/SuperPykkon/minecraft-server-web-console

download minecraft-server-web-console-master.zip
unzip and copy to /host/directory/admin

edit line 3to7 config/config.php

<pre>
define("SERVER_NAME", "example");
define("SERVER_IP", "127.0.0.1");
define("SERVER_PORT", "25565");

define("SERVER_ROOT_DIR", "/opt/minecraft/paper/");
define("SERVER_LOG_DIR", SERVER_ROOT_DIR . "logs/latest.log");
</pre>

edit line 10 exec.php
<pre>
$ss = shell_exec("ss -tulpn | grep :25565");
</pre>
