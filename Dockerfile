FROM java:openjdk-8-jre-alpine
MAINTAINER Justin Plock <justin@plock.net>

ENV ZK_VERSION="3.4.8"

RUN apk add --no-cache bash-completion

# timezone
RUN apk add --no-cache tzdata && \
       cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
       echo "Asia/Shanghai" >  /etc/timezone && \
       date && apk del --no-cache tzdata

# add zookeeper user
RUN groupadd -r -g 200 zookeeper && useradd -r -u 200 -g zookeeper zookeeper



RUN apk add --no-cache wget bash su-exec \
    && mkdir /opt \
    && wget -q -O - http://apache.mirrors.pair.com/zookeeper/zookeeper-${ZK_VERSION}/zookeeper-${ZK_VERSION}.tar.gz | tar -xzf - -C /opt \
    && mv /opt/zookeeper-$ZK_VERSION /opt/zookeeper \
    && chown zookeeper.zookeeper /opt/zookeeper -R

EXPOSE 2181 2888 3888

WORKDIR /opt/zookeeper

VOLUME /data

ENTRYPOINT ["/opt/zookeeper/bin/zkServer.sh"]
CMD ["start-foreground"]
