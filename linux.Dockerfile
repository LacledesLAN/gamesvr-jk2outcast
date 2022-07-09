# escape=`
FROM debian:buster-slim AS outcast-builder

RUN apt-get update && apt-get install -y`
        cmake debhelper devscripts git libsdl2-dev libgl1-mesa-dev libopenal-dev libjpeg-dev libpng-dev zlib1g-dev libminizip-dev

COPY ./sources/jk2mv /jk2mv

# Generate the default dedicated server configurations
RUN cd /jk2mv/build && ./build-dedicated.sh

# Build the dedicated server binaries
RUN cd /jk2mv/build/Linux-x86_64-dedicated && make;

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
COPY --chown=JK2Outcast:root --from=outcast-builder /jk2mv/build/Linux-x86_64-dedicated/out/Release/base /app/base
RUN true
COPY --chown=JK2Outcast:root --from=outcast-builder /jk2mv/build/Linux-x86_64-dedicated/out/Release /app
RUN true
COPY --chown=JK2Outcast:root dist/ /app/base

RUN chmod +x /app/jk2mvded

WORKDIR /app

USER JK2Outcast

CMD ["/bin/bash"]

ONBUILD USER root
