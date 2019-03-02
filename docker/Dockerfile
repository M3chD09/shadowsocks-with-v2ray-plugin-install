FROM alpine:latest

LABEL maintainer="m3chd09 <m3chd09@protonmail.com>"

RUN apk add --virtual .build-deps \
    tar \
    wget \
    build-base \
    pcre-dev \
    libsodium-dev \
    mbedtls-dev \
    asciidoc xmlto \
    libev-dev \
    c-ares-dev \
    linux-headers \
    && ss_file="$(wget -qO- https://api.github.com/repos/shadowsocks/shadowsocks-libev/releases/latest | grep name | grep tar | cut -f4 -d\")" \
    && v2_file="$(wget -qO- https://api.github.com/repos/shadowsocks/v2ray-plugin/releases/latest | grep linux-amd64 | grep name | cut -f4 -d\")" \
    && v2_url="$(wget -qO- https://api.github.com/repos/shadowsocks/v2ray-plugin/releases/latest | grep linux-amd64 | grep browser_download_url | cut -f4 -d\")" \
    && ss_url="$(wget -qO- https://api.github.com/repos/shadowsocks/shadowsocks-libev/releases/latest | grep browser_download_url | cut -f4 -d\")" \
    && wget $ss_url \
    && tar xf $ss_file \
    && wget $v2_url \
    && tar xf $v2_file \
    && mv v2ray-plugin_linux_amd64 /usr/bin/v2ray-plugin \
    && cd "$(echo ${ss_file} | cut -f1-3 -d\.)" \
    && ./configure --prefix=/usr --disable-documentation \
    && make \
    && make install \
    && cd .. \
    && apk add --no-cache rng-tools \
        $(scanelf --needed --nobanner /usr/bin/ss-* \
        | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
        | xargs -r apk info --installed \
        | sort -u) \
    && apk del .build-deps \
    && rm -rf $ss_file $v2_file "$(echo ${ss_file} | cut -f1-3 -d\.)"

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
