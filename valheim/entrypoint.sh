#!/bin/bash

set -o errexit
set -o pipefail

function ensure_steamcmd() {
	mkdir -vp /tmp/steamcmd
	cd /tmp/steamcmd

	if [ ! -f "./steamcmd.sh" ]; then
		wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
		tar -xvzf steamcmd_linux.tar.gz
		rm steamcmd_linux.tar.gz
	fi

	# Workaround for https://www.reddit.com/r/SteamCMD/comments/nv9oey/error_failed_to_install_app_xxx_disk_write_failure/
	mkdir -vp /home/steam-user/steamapps
}

function update_validate() {
	echo 'validating update'
	ensure_steamcmd
	cd /tmp/steamcmd
	./steamcmd.sh +force_install_dir /home/steam-user +login anonymous +app_update $GameId validate +quit
	echo 'validated update'
}

function update() {
	echo 'updating game'
	ensure_steamcmd
	cd /tmp/steamcmd
	./steamcmd.sh +force_install_dir /home/steam-user +login anonymous +app_update $GameId +quit
	echo 'updated game'
}


function start() {
	echo 'starting valheim'
	# Set ENV variables required by ValheimPlus, if it is installed.
	# https://github.com/valheimPlus/ValheimPlus/blob/799a52a225487cc52e01a3cd77b37aa0e50be048/resources/unix/start_server_bepinex.sh
    if [ -d "/home/steam-user/BepInEx" ]; then
		export DOORSTOP_ENABLE=TRUE
		export DOORSTOP_INVOKE_DLL_PATH=/home/steam-user/BepInEx/core/BepInEx.Preloader.dll
		export DOORSTOP_CORLIB_OVERRIDE_PATH=/home/steam-user//unstripped_corlib
		export LD_LIBRARY_PATH=/home/steam-user/doorstop_libs:$LD_LIBRARY_PATH
		export LD_PRELOAD=libdoorstop_x64.so:$LD_PRELOAD
		export DYLD_LIBRARY_PATH=/home/steam-user/doorstop_libs
		export DYLD_INSERT_LIBRARIES=/home/steam-user/doorstop_libs/libdoorstop_x64.so
	fi

    # Set ENV variables required by Valheim server.
	export LD_LIBRARY_PATH=./linux64:$LD_LIBRARY_PATH
	export SteamAppId=892970
	local start_command="./valheim_server.x86_64 -nographics -batchmode -port ${V_GAME_PORT:-2456} -name '${V_SERVER_NAME:-A Valheim server}' -world '${V_SAVE_NAME:-Dedicated}' -password '${V_PASSWORD:-secret}' -savedir '/mnt/game' -public ${V_PUBLIC:-0}"

	
	cd /home/steam-user
	echo "$start_command"
	eval "$start_command"
}

case "$1" in
update)
	update
	;;
update_validate)
	update_validate
	;;
start)
	start
	;;
*)
	update_validate
	start
	;;
esac
