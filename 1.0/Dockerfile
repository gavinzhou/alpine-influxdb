FROM alpine:3.4
MAINTAINER gavin zhou <gavin.zhou@gmail.com>

ENV INFLUXDB_VERSION 1.0.0
RUN buildDeps="wget gnupg tar ca-certificates make gcc musl-dev" && \
    apk add --no-cache $buildDeps curl bash && \
    update-ca-certificates && \
    gpg --keyserver hkp://ha.pool.sks-keyservers.net \
        --recv-keys 05CE15085FC09D18E99EFB22684A14CF2582E0C5 && \
    curl -sSL https://github.com/Yelp/dumb-init/archive/master.tar.gz | tar -xz && \
    cd dumb-init-master && gcc -std=gnu99 -s -Wall -Werror -O3 -o /sbin/dumb-init /dumb-init-master/dumb-init.c && \
    wget -q https://dl.influxdata.com/influxdb/releases/influxdb-${INFLUXDB_VERSION}-static_linux_amd64.tar.gz && \
    mkdir -p /usr/src && mkdir -p /influxdb/etc && \
    tar -C /usr/src -xzf influxdb-${INFLUXDB_VERSION}-static_linux_amd64.tar.gz && \
    rm -f /usr/src/influxdb-*/influxdb.conf && \
    chmod +x /usr/src/influxdb-*/* && \
    cp -a /usr/src/influxdb-*/* /usr/bin/ && \
    rm -rf *.tar.gz* /usr/src /root/.gnupg /dumb-init-master && \
    apk del --purge $buildDeps
COPY config.docker/influxdb.conf /etc/influxdb/influxdb.conf

EXPOSE 8083 8086

VOLUME /var/lib/influxdb

COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["influxd", "-config=/etc/influxdb/influxdb.conf"]
