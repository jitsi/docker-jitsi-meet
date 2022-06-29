FROM etherpad/etherpad:1.8.7
ARG ETHERPAD_PLUGINS="ep_align ep_disable_chat ep_font_size ep_image_upload ep_hide_referrer ep_whiteboard"
RUN { [ -z "${ETHERPAD_PLUGINS}" ] || \
      npm install --no-save ${ETHERPAD_PLUGINS}; } && \
    bin/installDeps.sh && \
    rm -rf ~/.npm
COPY --chown=etherpad:etherpad ./settings.json.docker /opt/etherpad-lite/settings.json
EXPOSE 9001
