#!/bin/bash
function gracefulShutdown {
  echo "Shutting down, stopping Minecraft Server!"
  cd /mnt/tools/mcrcon 
  mcrcon -H 127.0.0.1 -P 25575 -p $MC_RCON_PASSWORD say 'Server is shutting down!'
  sleep 5s
  mcrcon -H 127.0.0.1 -P 25575 -p $MC_RCON_PASSWORD save-off
  mcrcon -H 127.0.0.1 -P 25575 -p $MC_RCON_PASSWORD save-all
  mcrcon -H 127.0.0.1 -P 25575 -p $MC_RCON_PASSWORD stop
  echo "Succesfully stopped Minecraft Server."
  # do something..
}
trap gracefulShutdown SIGTERM
#------ Shutdown ^^ -------


set -o errexit
set -o pipefail

function ensure_server() {
	cd /home/minecraft-user/game
	if [ ! -f "./server-$MC_VERSION.jar" ]; then
		wget $MC_SERVER_JAR_URL
        mv server.jar server-$MC_VERSION.jar
	fi
    
    cd /mnt/game
    if [ ! -f "eula.txt" ]; then
		echo "eula=true" > eula.txt
	fi
}

function update() {
	echo 'updating game'
	ensure_server
	echo 'updated game'
}


function start() {	
	cd /mnt/game
    echo "updating server.properties in case there are any changes"
    rm -f server.properties
    envsubst < /home/minecraft-user/server.properties.bak > server.properties
    echo "updated server.properties"
    echo 'starting minecraft'	
    MINECRAFT_CMD="java -Xmx$MC_MAX_RAM -Xms$MC_MIN_RAM -jar /home/minecraft-user/game/server-$MC_VERSION.jar --port $MC_PORT --nogui --world $MC_WORLD --universe /mnt/game"
	echo "$MINECRAFT_CMD"
	eval "$MINECRAFT_CMD" &
	wait
}

case "$1" in
update)
	update
	;;
start)
	start
	;;
*)
	update
	start
	;;
esac