FROM vezajin/vrising:base
ENV GameId=1829350	
RUN apt-get update 
RUN apt-get clean \
	&& rm -rf /var/lib/apt/* /tmp/* /var/tmp/*

RUN mkdir -p /mnt/game/Settings
RUN chown steam-user: /mnt/game
VOLUME /mnt/game

RUN chmod u+w /mnt/game
COPY --chown=steam-user:steam-user --chmod=777 ./ServerGameSettings.json /mnt/game/Settings/

COPY --chown=steam-user:steam-user --chmod=777 ./entrypoint.sh /home/steam-user/

USER steam-user
WORKDIR /home/steam-user
VOLUME /home/steam-user

RUN /home/steam-user/entrypoint.sh update_validate

EXPOSE 9876/udp
EXPOSE 9877/udp

ENTRYPOINT ["/bin/bash", "/home/steam-user/entrypoint.sh"]
