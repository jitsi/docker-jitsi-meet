FROM ubuntu:18.04
RUN apt-get update && apt-get -y install wget curl unzip gnupg linux-image-extra-virtual default-jre-headless ffmpeg curl alsa-utils icewm xdotool xserver-xorg-input-void xserver-xorg-video-dummy
RUN apt-get -y dist-upgrade
RUN curl -sS -o - https://download.jitsi.org/jitsi-key.gpg.key          | apt-key add
RUN curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add
RUN echo "deb https://download.jitsi.org unstable/"                            > /etc/apt/sources.list.d/jitsi-unstable.list
RUN echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
RUN wget -N http://chromedriver.storage.googleapis.com/$(curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE)/chromedriver_linux64.zip -P ~/
RUN unzip ~/chromedriver_linux64.zip -d ~/
RUN rm ~/chromedriver_linux64.zip
RUN  mv -f ~/chromedriver /usr/local/bin/chromedriver
RUN chown root:root /usr/local/bin/chromedriver
RUN chmod 0755 /usr/local/bin/chromedriver
RUN apt-get -y install apt-transport-https ca-certificates
RUN apt-get update && apt-get -y install ffmpeg google-chrome-stable jibri
#RUN ln -s /lib/modules/4.15.0-45-generic /lib/modules/3.10.0-957.1.3.el7.x86_64 
#RUN echo "snd-aloop" >> /etc/modules
CMD java -Djava.util.logging.config.file=/etc/jitsi/jibri/logging.properties -jar /opt/jitsi/jibri/jibri.jar --config "/etc/jitsi/jibri/config.json"
