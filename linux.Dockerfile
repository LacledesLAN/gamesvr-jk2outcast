# escape=`
FROM lacledeslan/steamcmd:linux as outcast-builder

RUN echo "Downloading JK2MV Dedicated Server from GitHub server" &&`
        mkdir --parents /downloads/jk2mv-dedicated &&`
        curl -LJ -o /downloads/jk2mv-dedicated/jk2vm-dedicated.zip https://github.com/mvdevs/jk2mv/releases/download/1.4.1/jk2mv-v1.4.1-dedicated.zip &&`
    echo "Validating download against last known hash" &&`
        echo "e314e8bb1f46a42a19e133d6a317a43d5f59e71bf1606d70ad2c40be95c6abba  /downloads/jk2mv-dedicated/jk2vm-dedicated.zip" | sha256sum -c - &&`
    echo "Extracting JK2MV Dedicated Server files" &&`
        unzip /downloads/jk2mv-dedicated/jk2vm-dedicated.zip -d /downloads/jk2mv-dedicated;

#=======================================================================

FROM debian:buster-slim

ARG BUILDNODE=unspecified
ARG SOURCE_COMMIT=unspecified

HEALTHCHECK NONE

RUN dpkg --add-architecture i386 &&`
    apt-get update && apt-get install -y `
        locales locales-all &&`
    apt-get clean &&`
    echo "LC_ALL=en_US.UTF-8" >> /etc/environment &&`
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*;

ENV LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

LABEL com.lacledeslan.build-node=$BUILDNODE `
      org.label-schema.schema-version="1.0" `
      org.label-schema.url="https://github.com/LacledesLAN/README.1ST" `
      org.label-schema.vcs-ref=$SOURCE_COMMIT `
      org.label-schema.vendor="Laclede's LAN" `
      org.label-schema.description="Jedi Knight II: Jedi Outcast Dedicated Server" `
      org.label-schema.vcs-url="https://github.com/LacledesLAN/gamesvr-jk2outcast"

# Set up Enviornment
RUN useradd --home /app --gid root --system JK2Outcast &&`
    mkdir -p /app &&`
    chown JK2Outcast:root -R /app;

# `RUN true` lines are work around for https://github.com/moby/moby/issues/36573
COPY --chown=JK2Outcast:root --from=outcast-builder /downloads/jk2mv-dedicated/base /app/base
RUN true
COPY --chown=JK2Outcast:root --from=outcast-builder /downloads/jk2mv-dedicated/linux-amd64 /app

RUN chmod +x /app/jk2mvded

WORKDIR /app

CMD ["/bin/bash"]

ONBUILD USER root
