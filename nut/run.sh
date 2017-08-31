#!/bin/bash
set -e

CONFIG_PATH=/data/options.json

# Generate upsd.users
LOGINS=$(jq --raw-output ".logins | length" $CONFIG_PATH)
echo "" > /etc/nut/upsd.users
if [ "$LOGINS" -gt "0" ]; then
    for (( i=0; i < "$LOGINS"; i++ )); do
        USERNAME=$(jq --raw-output ".logins[$i].username" $CONFIG_PATH)
        PASSWORD=$(jq --raw-output ".logins[$i].password" $CONFIG_PATH)
        INSTCMDS=$(jq --raw-output ".logins[$i].instcmds" $CONFIG_PATH)
	echo "[$USERNAME]"            >> /etc/nut/upsd.users
        echo "  password = $PASSWORD" >> /etc/nut/upsd.users
        echo "  instcmds = $INSTCMDS" >> /etc/nut/upsd.users
        echo ""                       >> /etc/nut/upsd.users
    done
fi

# Generate ups.conf
UPS=$(jq --raw-output ".ups | length" $CONFIG_PATH)
echo "" > /etc/nut/ups.conf
if [ "$UPS" -gt "0" ]; then
    for (( i=0; i < "$LOGINS"; i++ )); do
        UPSNAME=$(jq --raw-output ".ups[$i].upsname" $CONFIG_PATH)
        DRIVER=$(jq --raw-output ".ups[$i].driver" $CONFIG_PATH)
        PORT=$(jq --raw-output ".ups[$i].port" $CONFIG_PATH)
	echo "[$UPSNAME]"         >> /etc/nut/ups.conf
        echo "  driver = $DRIVER" >> /etc/nut/ups.conf
        echo "  port = $PORT"     >> /etc/nut/ups.conf
        echo ""                   >> /etc/nut/ups.conf
    done
fi

# Generate upsd.conf
BINDADDR=$(jq --raw-output ".bindaddr" $CONFIG_PATH)
BINDPORT=$(jq --raw-output ".bindport" $CONFIG_PATH)
echo "LISTEN $BINDADDR $BINDPORT" > /etc/nut/upsd.conf

# Generate nut.conf
MODE=$(jq --raw-output ".mode" $CONFIG_PATH)
echo "MODE=$MODE" > /etc/nut/nut.conf

# change perms on config files
chmod 660 /etc/nut/*

# grant access to all usb devices
chmod 777 /dev/bus/usb/*/*

upsdrvctl start
upsd -D
