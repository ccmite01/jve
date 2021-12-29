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
      - '0.0.0.0:25565:25566'
      - '0.0.0.0:25575:25575'
      - '0.0.0.0:25555:22'
      - '0.0.0.0:8443:8443'
      - '0.0.0.0:8123:8123'
      - '0.0.0.0:8192:8192'
    volumes:
      - '/opt/minecraft/servers:/opt/minecraft'
      - '/opt/minecraft/admin:/var/www/html'
      - '/opt/minecraft/dynmapweb:/opt/minecraft/paper/plugins/dynmap/web'
    environment:
      MC_INSTANCE_NAME: paper
      MC_VERSION: 1.18.1
      MC_PAPER_BUILD: 110
      MC_RAM: 4G
      MC_CPU_CORE: 2
      LANG: ja-JP.UTF-8
    mem_limit: 5g
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
      - '/opt/minecraft/coreprotectdb:/var/lib/mysql'
    environment:
      MARIADB_ROOT_PASSWORD: do_not_copy_and_paste
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
      - '/opt/minecraft/servers:/opt/minecraft'
      - '/opt/minecraft/backup:/var/spool/cron'
      - '/var/run/docker.sock:/var/run/docker.sock'
      - '/opt/docker-compose:/opt/docker-compose'
    environment:
      LANG: ja-JP.UTF-8
      MC_INSTANCE_NAME: paper
      MC_SRVIP: jve
      MC_SSH: /usr/bin/ssh
      MC_SSHPORT: 22
      MC_USER: root
      MC_RCON: /usr/bin/mcrcon
      MC_RCONPORT: 25575
      MC_RCONPASS: do_not_copy_and_paste
    mem_limit: 256m
</pre>


# WebConsole

*  Forked from SuperPykkon/minecraft-server-web-console
<pre>
http://serverIP:8443/console/
username: admin
password: do_not_copy_and_paste
</pre>
