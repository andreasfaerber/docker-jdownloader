#!/bin/sh

while true; do
  /opt/JDownloader/daemon.sh
  sleep 5
  echo "JDownloader exited"
  [[ $RUN_IN_LOOP == 1 ]] || break
done
