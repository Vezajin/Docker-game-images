FROM vezajin/valheim:base
ENV GameId=896660	
RUN apt-get update 
RUN apt-get clean \
	&& rm -rf /var/lib/apt/* /tmp/* /var/tmp/*

RUN mkdir -p /mnt/game
RUN chown steam-user: /mnt/game
VOLUME /mnt/game

RUN chmod u+w /mnt/game


COPY --chown=steam-user:steam-user --chmod=777 ./entrypoint.sh /home/steam-user/
RUN chown -R steam-user:steam-user /home/steam-user

USER steam-user
WORKDIR /home/steam-user
VOLUME /home/steam-user

RUN /home/steam-user/entrypoint.sh update_validate

EXPOSE 2456/udp
EXPOSE 2457/udp

ENTRYPOINT ["/bin/bash", "/home/steam-user/entrypoint.sh"]
