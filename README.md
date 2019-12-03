This docker image provides a Minecraft Plug-in Server that will automatically download the PAPER(spigot fork) selectable version at startup.

# To simply use the latest stable version, run
docker run -d -p 25565:25565 -p 80:80 -v /host/directory/servers:/opt/minecraft -v /host/directory/admin:/var/www/html --name jve ccmite/jve


# Example Docker Compose app

* docker-compose.yml

<pre>
version: '2'
services:
# Minecraft Server ###################################################
  jve:
    image: ccmite/jve:latest
    container_name: jve
    hostname: jve
    tty: true
    restart: always
    ports:
      - '0.0.0.0:25565:25565'
      - '0.0.0.0:25575:25575'
      - '0.0.0.0:80:80'
    volumes:
      - '/host/directory/servers:/opt/minecraft'
      - '/host/directory/admin:/var/www/html'
    environment:
      MC_INSTANCE_NAME: paper
      MC_VERSION: 1.14.4
      MC_PAPER_BUILD: 233
      MC_RAM: 4G
      MC_CPU_CORE: 1
      LANG: ja-JP.UTF-8
    mem_limit: 5g
    depends_on:
      - db
# CoreProtect DB Server ##############################################
  db:
    image: ccmite/db:latest
    container_name: db
    hostname: db
    tty: true
    restart: always
    ports:
      - '0.0.0.0:3306:3306'
    volumes:
      - '/host/directory/db:/var/lib/mysql'
    environment:
      MARIADB_ROOT_PASSWORD: secretpass
      MARIADB_DATABASE: coreprotect
      MARIADB_INITDB_SKIP_TZINFO: "true"
      LANG: ja-JP.UTF-8
    mem_limit: 256m
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
