FROM php:7.4.0-apache-buster
LABEL maintainer="ccmite"
WORKDIR /

COPY start.sh /
COPY console.tar.gz /

RUN : "add package" && \
    apt --allow-releaseinfo-change update && apt install -y \
    screen \
    sudo \
    iproute2 \
    locales \
    ssh \
    dnsutils \
    whois \
    mtr \
    && apt-get clean && rm -rf /var/lib/apt/lists/* && \
    echo "www-data ALL=NOPASSWD: ALL" >> /etc/sudoers && \
    sed -i 's/# ja_JP.UTF-8 UTF-8/ja_JP.UTF-8 UTF-8/g' /etc/locale.gen && \
    locale-gen ja_JP.UTF-8 && \
    update-locale LANG=ja_JP.UTF-8 && \
    rm -f /etc/localtime && \
    ln -s /usr/share/zoneinfo/Japan /etc/localtime && \
    echo "Asia/Tokyo" > /etc/timezone && \
    ln -s /opt/minecraft/ssh/authorized_keys /etc/ssh/authorized_keys && \
    sed -i 's/#Port 22/Port 22/g' /etc/ssh/sshd_config && \
    sed -i 's/#ListenAddress 0.0.0.0/ListenAddress 0.0.0.0/g' /etc/ssh/sshd_config && \
    sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config && \
    echo "AuthorizedKeysFile /etc/ssh/authorized_keys" >> /etc/ssh/sshd_config && \
    mkdir -p /usr/lib/jvm && \
    cd /usr/lib/jvm && \
    curl -s -k -L --tlsv1.2 https://github.com/AdoptOpenJDK/openjdk13-binaries/releases/download/jdk-13%2B33_openj9-0.16.0/OpenJDK13U-jre_x64_linux_openj9_13_33_openj9-0.16.0.tar.gz -o jdk.tar.gz && \
    tar -xzf jdk.tar.gz && \
    rm -f jdk.tar.gz && \
    update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk-13+33-jre/bin/java" 1 && \
    chmod +x /start.sh && \
    echo "nicname 43/tcp whois" >> /etc/services && \
    echo "nicname 43/udp whois" >> /etc/services && \
    echo '[Date]' > /usr/local/etc/php/php.ini  && \
    echo 'date.timezone = "Asia/Tokyo"' >> /usr/local/etc/php/php.ini

ENV MC_VERSION="1.14.4" MC_PAPER_BUILD="latest" MC_RAM="4G" MC_CPU_CORE="1" MC_INSTANCE_NAME="paper"

ENTRYPOINT ["sh", "/start.sh"]
EXPOSE 22 25565 25575 80 8123 8192
