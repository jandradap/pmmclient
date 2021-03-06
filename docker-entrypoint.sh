#!/bin/bash
# -*- ENCODING: UTF-8 -*-
# ------------------------------------------------------------------
# Title: Migra el historial de conversaciones gajim
# Autor: [Jorge Andrada] [jandrada@gmail.com]
# ------------------------------------------------------------------

PMM_SERVER_PORT=80

#copio los binarios en caso de montar volumen
for BINARIO in /usr/src/*
do
	BINARIO=$(echo $BINARIO | awk -F "/" '{print$4}')
	echo $BINARIO
	if [ ! -f /usr/local/percona/pmm-client/$BINARIO ]; then cp -a /usr/src/$BINARIO /usr/local/percona/pmm-client/; fi
done

#limpieza de conexiones anteriores
if [ -f /usr/local/percona/pmm-client/pmm.yml ]; then
	{
		echo -e "Clean old data and config..."
		pmm-admin purge
		pmm-admin uninstall
		if [ -f /usr/local/percona/pmm-client/pmm.yml ]; then rm /usr/local/percona/pmm-client/pmm.yml; fi
		if [ -f /usr/local/percona/pmm-client/server.crt ]; then rm /usr/local/percona/pmm-client/server.crt; fi
		if [ -f /usr/local/percona/pmm-client/server.key ]; then rm /usr/local/percona/pmm-client/server.key; fi
	}
fi

#registro del servidor
registro=0
while  [ $registro == 0 ]; do
	pmm-admin uninstall
	echo -e "\nWaiting PMM Server: $PMM_SERVER at port $PMM_SERVER_PORT"
	pmm-admin config --server $PMM_SERVER:$PMM_SERVER_PORT
	if [ $? == 0 ]; then registro=1; fi
	sleep 10
done

#fix mysql to be online
sleep $WAITTIME
echo -e "\nWaiting PMM Server sync: $PMM_SERVER"
pmm-admin add mysql --user $MYSQL_ROOT_USER --password $MYSQL_ROOT_PASSWORD --host $MYSQL_HOST --create-user --create-user-password $PMM_CLIENT_PASSWORD --force

#fix for exit container
tail -f /dev/null
