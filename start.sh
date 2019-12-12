#!/bin/bash
if [ ! -d /opt/minecraft/${MC_INSTANCE_NAME} ]
    then
    mkdir -p /opt/minecraft/${MC_INSTANCE_NAME}
    chown www-data:www-data /opt/minecraft/${MC_INSTANCE_NAME}
fi

if [ ! -d /var/www/html/console ]
    then
    tar -x -v -f /console.tar.gz -C /var/www/html/
    chmod +x /var/www/html/console/*.sh
    sed -i "s/ccmite/${MC_INSTANCE_NAME}/g" /var/www/html/console/config/config.php
fi

result=`grep "ROUTER" /etc/hosts`
if [ -n "${result}" ]; then
    echo "192.168.0.1 ROUTER" >> /etc/hosts
fi

cd /opt/minecraft/${MC_INSTANCE_NAME}
if [ ! -e papermc-${MC_VERSION}-${MC_PAPER_BUILD}.jar ]
  then
   curl -s -k --tlsv1.2 https://papermc.io/api/v1/paper/${MC_VERSION}/${MC_PAPER_BUILD}/download -o papermc-${MC_VERSION}-${MC_PAPER_BUILD}.jar
   echo 'eula=true' > eula.txt
   chown -R www-data:www-data *
fi
screen -S apc /usr/sbin/apachectl start
mkdir -p /opt/minecraft/ssh
touch /opt/minecraft/ssh/authorized_keys
chown root:root /opt/minecraft/ssh/authorized_keys
chmod 600 /opt/minecraft/ssh/authorized_keys
/etc/init.d/ssh start
screen -S mcs su -s /bin/bash - www-data -c "export $TZ=JST-9; export $LANG=ja_JP.UTF-8; cd /opt/minecraft/${MC_INSTANCE_NAME}; /usr/bin/java -server -Xms${MC_RAM} -Xmx${MC_RAM} -XX:MetaspaceSize=512M -XX:+UseG1GC -XX:+UseStringDeduplication -XX:+DisableExplicitGC -XX:+UseCompressedOops -XX:+OptimizeStringConcat -XX:MaxGCPauseMillis=50 -XX:+UseTLAB -XX:ParallelGCThreads=${MC_CPU_CORE} -jar papermc-${MC_VERSION}-${MC_PAPER_BUILD}.jar nogui"
