#!/bin/sh
set -e

echo "eula=true" > eula.txt

DOCKER_USER='minecraft'
DOCKER_GROUP='minecraft'

if ! id "$DOCKER_USER" >/dev/null 2>&1; then
    echo "First start of the docker container, starting initialization process."

    USER_ID=${PUID:-9001}
    GROUP_ID=${PGID:-9001}
    echo "Starting with $USER_ID:$GROUP_ID (UID:GID)"

    # Use Alpine's native addgroup/adduser instead of shadow package
    addgroup -g "$GROUP_ID" "$DOCKER_GROUP"
    adduser -u "$USER_ID" -G "$DOCKER_GROUP" -s /bin/sh -D "$DOCKER_USER"

    chown -R "$USER_ID:$GROUP_ID" /opt/minecraft
    chmod -R ug+rwx /opt/minecraft
    chown -R "$USER_ID:$GROUP_ID" /data
fi

export HOME=/home/$DOCKER_USER
exec gosu "$DOCKER_USER:$DOCKER_GROUP" java -jar -Xms"$MEMORYSIZE" -Xmx"$MEMORYSIZE" $JAVAFLAGS /opt/minecraft/fabric.jar nogui
