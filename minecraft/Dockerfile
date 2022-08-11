FROM vezajin/minecraft:base

RUN mkdir -p /mnt/game/backup
RUN chown -R minecraft-user: /mnt/game
VOLUME /mnt/game
RUN chmod -R u+w /mnt/game


RUN mkdir -p /home/minecraft-user/game
RUN chown minecraft-user: /home/minecraft-user/game
VOLUME /home/minecraft-user/game
RUN chmod u+w /home/minecraft-user/game

COPY --chown=minecraft-user:minecraft-user --chmod=777 ./files/* /home/minecraft-user/

USER minecraft-user
WORKDIR /home/minecraft-user

EXPOSE 25565
EXPOSE 25575

ENTRYPOINT ["/bin/bash", "/home/minecraft-user/entrypoint.sh"]
