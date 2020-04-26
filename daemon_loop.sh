#!/bin/sh

while true; do
  /opt/JDownloader/daemon.sh
  [[ $RUN_IN_LOOP == 1 ]] || break
done
