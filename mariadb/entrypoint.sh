#!/bin/bash

set -e
trap "echo SIGNAL" HUP INT QUIT KILL TERM
echo "Welcome to the MariaDB container"

if [ -z "$MARIADB_ROOT_PASSWORD" ]
then
	echo "You need to specify a root password"
	exit 1
fi

read -r -d '' initUserTable <<-EOSQL || true
	SET password FOR 'root'@'localhost' = password('${MARIADB_ROOT_PASSWORD}');
	SET password FOR 'root'@'127.0.0.1' = password('${MARIADB_ROOT_PASSWORD}');
	SET password FOR 'root'@'::1' = password('${MARIADB_ROOT_PASSWORD}');
	CREATE USER 'root'@'${MARIADB_ROOT_HOST}';
	SET password FOR 'root'@'${MARIADB_ROOT_HOST}' = password('${MARIADB_ROOT_PASSWORD}');
	GRANT ALL PRIVILEGES ON *.* TO 'root'@'${MARIADB_ROOT_HOST}';
	FLUSH PRIVILEGES;
EOSQL


/usr/sbin/mysqld --skip-networking &
pid="$!"
for i in {10..1}
do
	if echo 'SELECT 1' | mysql &> /dev/null; then break; fi
	sleep 1
done
echo "$initUserTable" | mysql
kill $pid
sleep 2


args=""
if [ "${1:0:1}" == "-" ] ; then
	exec /usr/sbin/mysqld "$@"
fi

if [ "$1" == "/usr/sbin/mysqld" ] ; then
	exec "$@"
fi

if [ "$1" == "mysqld" ] ; then
	exec /usr/sbin/mysqld
fi


exec "$@"


# vim: ft=sh
