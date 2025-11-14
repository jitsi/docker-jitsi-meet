FROM jitsi/web:web-1.0.8928-1

USER root

RUN apt-get update && apt-get -y install --reinstall build-essential && apt-get -y install curl gnupg git && curl -sL https://deb.nodesource.com/setup_lts.x | bash - && apt-get -y install nodejs

ENV NODE_OPTIONS=--max_old_space_size=4096

COPY ./jitsi-meet /usr/share/jitsi-meet

COPY assets/watermark.svg              /usr/share/jitsi-meet/images/watermark.svg
COPY assets/title.html                 /usr/share/jitsi-meet/title.html
COPY assets/favicon.ico                /usr/share/jitsi-meet/images/favicon.ico
COPY assets/apple-touch-icon.png       /usr/share/jitsi-meet/images/apple-touch-icon.png
COPY assets/images/virtual-background/ /usr/share/jitsi-meet/images/virtual-background/
COPY assets/lang/main.json             /usr/share/jitsi-meet/lang/main.json

RUN cd /usr/share/jitsi-meet && npm install && make all

EXPOSE 80 443

# VOLUME ["/config", "/etc/letsencrypt", "/usr/share/jitsi-meet/transcripts"]