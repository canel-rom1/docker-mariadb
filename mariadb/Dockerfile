FROM canelrom1/debian-canel:latest
LABEL maintainer="Rom1 <rom1@canel.ch> - CANEL - https://www.canel.ch"
LABEL date="27/01/18"
LABEL description="Serveur DB - MariaDB"

ENV MARIADB_VERSION=10.3

RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xF1656F24C74CD1D8 \
 && echo "deb http://ftp.eenet.ee/pub/mariadb/repo/${MARIADB_VERSION}/debian/ stretch main" \
         > /etc/apt/sources.list.d/mariadb.list \
 && apt-get update \
 && apt-get -y -q --no-install-recommends \
    install mariadb-server \
 && find /var/lib/apt/lists -type f -delete

COPY ./conf/my.cnf /etc/mysql/my.cnf

EXPOSE 3306

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["mysqld"]
