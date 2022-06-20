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
	mkdir -vp /home/v-rising-user/steamapps
}

function install() {
	echo 'validating & installing'
	ensure_steamcmd
	cd /tmp/steamcmd
	./steamcmd.sh +force_install_dir /home/v-rising-user +login anonymous +app_update 1829350 validate +quit
	echo 'validated & installed'
}


install
	
