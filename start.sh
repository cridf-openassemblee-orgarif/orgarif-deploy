source env.sh
git reset --hard origin/$ENV
# kill previous one ?
java -Dspring.profiles.active=dev,local-mlo -jar orgarif-server.jar