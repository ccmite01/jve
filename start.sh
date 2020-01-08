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
screen -S mcs su -s /bin/bash - www-data -c "export TZ=JST-9; export LANG=ja_JP.UTF-8; cd /opt/minecraft/${MC_INSTANCE_NAME}; /usr/bin/java -server -Xms${MC_RAM} -Xmx${MC_RAM} -XX:MaxNewSize=1G -XX:MetaspaceSize=1G -XX:MaxMetaspaceSize=1G -XX:+UseG1GC -XX:ParallelGCThreads=${MC_CPU_CORE} -XX:ConcGCThreads=2 -XX:TargetSurvivorRatio=90 -XX:MaxTenuringThreshold=15 -XX:+DisableExplicitGC -XX:+CMSParallelRemarkEnabled -XX:+ScavengeBeforeFullGC -XX:-UseGCOverheadLimit -XX:-UseAdaptiveSizePolicy -XX:+UseTLAB -XX:+UseBiasedLocking -XX:+UseLargePages -XX:+TieredCompilation -XX:+UseCompressedOops -jar papermc-${MC_VERSION}-${MC_PAPER_BUILD}.jar nogui"
