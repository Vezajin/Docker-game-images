FROM ubuntu:22.04

RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y wine32

RUN export DEBIAN_FRONTEND=noninteractive
RUN groupadd -g 1000 v-rising-user \
	&& useradd -m -d /home/v-rising-user -u 1000 -g 1000 v-rising-user 
	
RUN apt-get update \
	&& apt-get install -y lib32stdc++6 lib32gcc-s1 wget tar tzdata libsdl2-dev wine64 xvfb \


RUN apt-get clean \
	&& rm -rf /var/lib/apt/* /tmp/* /var/tmp/*

COPY --chown=v-rising-user:v-rising-user --chmod=777 ./entrypoint.sh /v-rising-user/
COPY --chown=v-rising-user:v-rising-user --chmod=777 ./init_game.sh /v-rising-user/

USER v-rising-user
WORKDIR /home/v-rising-user
VOLUME /home/v-rising-user

RUN /v-rising-user/init_game.sh

RUN mkdir -p ./data/Settings
COPY --chown=v-rising-user:v-rising-user --chmod=777 ./ServerGameSettings.json .data/Settings/

EXPOSE 9876/udp
EXPOSE 9877/udp

ENTRYPOINT ["/bin/bash", "/v-rising-user/entrypoint.sh"]
