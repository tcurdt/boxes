FROM registry:2

USER daemon
WORKDIR /config
VOLUME [ "/storage", "/config" ]
ENTRYPOINT [ "registry" ]
CMD [ "/config/config.yml" ]