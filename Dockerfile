# -- Build ---
FROM azul/zulu-openjdk-alpine:25 AS build

ARG TARGETARCH
ARG MCVERSION
RUN if [ -z "$MCVERSION" ]; then echo "❌ ERROR: MCVERSION build argument is required"; exit 1; fi

ARG RCON_CLI_VER=1.6.0

RUN apk add --no-cache \
    curl \
    jq

WORKDIR /opt/minecraft

COPY ./fabric_version.txt /fabric_version.txt
COPY ./getfabricserver.sh /getfabricserver.sh
RUN chmod +x /getfabricserver.sh && \
    sh /getfabricserver.sh ${MCVERSION}

# Download RCON CLI
RUN curl -fsSL "https://github.com/itzg/rcon-cli/releases/download/${RCON_CLI_VER}/rcon-cli_${RCON_CLI_VER}_linux_${TARGETARCH}.tar.gz" -o rcon-cli.tgz && \
    tar -x -f rcon-cli.tgz rcon-cli && \
    rm rcon-cli.tgz

# --- Runtime ---
FROM azul/zulu-openjdk-alpine:25-jre AS runtime

WORKDIR /data

# Install su-exec (lightweight gosu alternative for Alpine)
RUN apk add --no-cache su-exec && \
    ln -s /sbin/su-exec /usr/bin/gosu

COPY --from=build /opt/minecraft/fabric.jar /opt/minecraft/fabric.jar
COPY --from=build /opt/minecraft/rcon-cli /usr/local/bin/rcon-cli
RUN chmod +x /usr/local/bin/rcon-cli

VOLUME "/data"

EXPOSE 25565/tcp
EXPOSE 25565/udp

# Environment variables with defaults
ENV MEMORYSIZE=5G
ENV JAVAFLAGS="--add-modules=jdk.incubator.vector -Dlog4j2.formatMsgNoLookups=true -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=mcflags.emc.gs"

COPY /docker-entrypoint.sh /opt/minecraft
RUN chmod +x /opt/minecraft/docker-entrypoint.sh

# Healthcheck using rcon-cli (requires RCON enabled in server.properties)
HEALTHCHECK --interval=60s --timeout=10s --start-period=120s --retries=3 \
    CMD rcon-cli --host localhost --port 25575 --password minecraft ping || exit 1

LABEL maintainer="Sebas Álvaro <https://alvaros.dev>"

ENTRYPOINT ["/opt/minecraft/docker-entrypoint.sh"]
