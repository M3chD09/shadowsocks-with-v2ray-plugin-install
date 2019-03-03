#!/bin/sh

SS_CONFIG=${SS_CONFIG:-""}
SS_PORT=${SS_PORT:-"8008"}
SS_METHOD=${SS_METHOD:-"aes-256-gcm"}
SS_PASSWORD=${SS_PASSWORD:-"password"}

while getopts "s:p:m:k:" OPT; do
    case $OPT in
        s)
            SS_CONFIG=$OPTARG;;
        p)
            SS_PORT=$OPTARG;;
        m)
            SS_METHOD=$OPTARG;;
        k)
            SS_PASSWORD=$OPTARG;;
    esac
done

if [ "${SS_CONFIG}" != "" ]; then
    ss-server ${SS_CONFIG}
else
    ss-server -s 0.0.0.0 -p $SS_PORT -m $SS_METHOD -k $SS_PASSWORD --plugin v2ray-plugin --plugin-opts "server"
fi
