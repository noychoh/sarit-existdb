#!/usr/bin/env bash

# Start up exist, and then shutdown: useful to prepare collection in
# docker image (indexes on creation of image, not afterwards).

if [ -d ./exist ] && [ -f ./exist/start.jar ]
then
    STARTDIR=$(pwd)
    echo "eXist seems to be in $STARTDIR/exist"
else
    echo "Could not find exist rootdir"
    exit 1
fi

cd $STARTDIR/exist

mkdir -p ./webapp/WEB-INF/logs/
touch ./webapp/WEB-INF/logs/exist.log
java -jar start.jar jetty &
EXPROC=$!
echo "Waiting for completion of existdb ..."
grep -m 1 "Server has started, listening on" <(tail -f ./webapp/WEB-INF/logs/exist.log)
sleep 10
echo "Shut down existdb ($EXPROC) ..."
./bin/shutdown.sh

cd $STARTDIR
