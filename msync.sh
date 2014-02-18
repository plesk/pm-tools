#!/bin/sh

HOST=$1

if [ "$1" = "--help" -o "$1" = "-h" ]; then
    echo "USAGE: $0 <remote host>";
    exit 1;
fi;

if [ -z "$HOST" ]; then
    echo "Please specify destination host."
    exit 1
fi

if [ ! -f meta.xml ]; then
    echo "Failed: need to run inside Plesk module code root."
    exit 2
fi

MODULE=`cat meta.xml | grep '<id>' | sed -E -e 's/.+>([^<]+)<.+/\1/g'`

echo "Syncing module $MODULE"
echo "---"

[ -d htdocs ] && rsync -rva htdocs/* root@$HOST:/usr/local/psa/admin/htdocs/modules/$MODULE/
[ -d plib ] && rsync -rva plib/* root@$HOST:/usr/local/psa/admin/plib/modules/$MODULE/

if [ -d sbin ]; then
    rsync -rva sbin/* root@$HOST:/usr/local/psa/admin/sbin/modules/$MODULE/
    ssh root@$HOST "chmod +x /usr/local/psa/admin/sbin/modules/$MODULE/*"
    ssh root@$HOST "chown root:psaadm /usr/local/psa/admin/sbin/modules/$MODULE/*"
    ssh root@$HOST "mkdir -p /usr/local/psa/admin/bin/modules/$MODULE/"
    pushd sbin
        for FILE in `ls *`; do
            ssh root@$HOST "ln -sf ../../../sbin/mod_wrapper /usr/local/psa/admin/bin/modules/$MODULE/$FILE"
        done
    popd
fi

rsync -rva meta.xml root@$HOST:/usr/local/psa/admin/plib/modules/$MODULE/
