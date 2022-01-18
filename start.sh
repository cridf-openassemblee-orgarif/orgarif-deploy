source env.sh
source secrets.sh
#git reset --hard origin/$ENV
# kill previous one ?
#java -jar orgarif-server.jar
java -Dspring.profiles.active=prod -jar orgarif-server.jar