#!/bin/bash
#ejeución de pmm_server

registro=0
while  [ $registro == 0 ]; do
	pmm-admin uninstall
	echo -e "\nEsperando la conexión con el servidor PMM $PMM_SERVER"
	pmm-admin config --server $PMM_SERVER
	if [ $? == 0 ]; then registro=1; fi
	sleep 10
done

# conexion=0
# while  [ $conexion == 0 ]; do
# 	echo "Esperando la sincronización con el servidor PMM $PMM_SERVER"
# 	pmm-admin add mysql --user root --password root --host db --port 3306 --create-user --force
# 	if [ $? == 0 ]; then conexion=1; fi
# 	sleep 10
# done

sleep $WAITTIME
echo -e "\nEsperando la sincronización con el servidor PMM $PMM_SERVER"
pmm-admin add mysql --user $MYSQL_ROOT_USER --password $MYSQL_ROOT_PASSWORD --host $MYSQL_HOST --create-user --create-user-password $PMM_CLIENT_PASSWORD

tail -f /dev/null
