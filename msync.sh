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

rsync -rva htdocs/* root@$HOST:/usr/local/psa/admin/htdocs/modules/$MODULE/ --exclude .svn
rsync -rva plib/* root@$HOST:/usr/local/psa/admin/plib/modules/$MODULE/ --exclude .svn
rsync -rva meta.xml root@$HOST:/usr/local/psa/admin/plib/modules/$MODULE/
