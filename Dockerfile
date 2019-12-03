FROM php:7.4.0-apache-buster
LABEL maintainer="ccmite"
WORKDIR /

RUN : "add package" && \
    apt --allow-releaseinfo-change update && apt install -y \
    screen \
    sudo \
    iproute2 \
    locales \
    && apt-get clean && rm -rf /var/lib/apt/lists/* && \
    echo "www-data ALL=NOPASSWD: ALL" >> /etc/sudoers && \
    sed -i 's/# ja_JP.UTF-8 UTF-8/ja_JP.UTF-8 UTF-8/g' /etc/locale.gen && \
    locale-gen ja_JP.UTF-8 && \
    update-locale LANG=ja_JP.UTF-8 && \
    rm -f /etc/localtime && \
    ln -s /usr/share/zoneinfo/Japan /etc/localtime && \
    echo "Asia/Tokyo" > /etc/timezone

RUN : "add java" && \
    mkdir -p /usr/lib/jvm && \
    cd /usr/lib/jvm && \
    curl -s -k -L --tlsv1.2 https://github.com/AdoptOpenJDK/openjdk13-binaries/releases/download/jdk-13%2B33_openj9-0.16.0/OpenJDK13U-jre_x64_linux_openj9_13_33_openj9-0.16.0.tar.gz -o jdk.tar.gz && \
    tar -xzf jdk.tar.gz && \
    rm -f jdk.tar.gz && \
    update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk-13+33-jre/bin/java" 1

COPY start.sh /
RUN chmod +x /start.sh

ENV MC_VERSION="1.14.4" MC_PAPER_BUILD="latest" MC_RAM="2G" MC_CPU_CORE="1" MC_INSTANCE_NAME="default"

#ENTRYPOINT ["tail", "-f", "/dev/null"]
ENTRYPOINT ["sh", "/start.sh"]
EXPOSE 25565 25575 80 8123 8192
