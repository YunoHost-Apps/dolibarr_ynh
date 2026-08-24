#!/bin/bash
/usr/local/bin/syncyunohost.sh
if [[ $? -ne 0 ]]; then
       echo "Le service syncyunohost s'est arrete en erreur" | mail -s "Syncyunohost de Habicoop" __ADMIN_MAIL__
fi
