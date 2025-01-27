#!/bin/bash
source ./env.sh
source ./secrets.sh
exec java -Dspring.profiles.active=prod -jar orgarif-server.jar