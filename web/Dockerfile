FROM jitsi/web:web-1.0.8928-1

USER root

RUN apt-get update && apt-get -y install --reinstall build-essential && apt-get -y install curl gnupg git && curl -sL https://deb.nodesource.com/setup_lts.x | bash - && apt-get -y install nodejs

COPY ./jitsi-meet /usr/share/jitsi-meet

RUN cd /usr/share/jitsi-meet && npm install && make all

EXPOSE 80 443

# VOLUME ["/config", "/etc/letsencrypt", "/usr/share/jitsi-meet/transcripts"]