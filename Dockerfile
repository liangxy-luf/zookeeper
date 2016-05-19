FROM java:openjdk-8-jre-alpine
MAINTAINER zhouyq <zhouyq@goodrain.com>

ENV ZK_VERSION="3.4.8"
ENV NODENET_VERSION="V2"
# timezone
RUN apk add --no-cache tzdata && \
       cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
       echo "Asia/Shanghai" >  /etc/timezone && \
       date && apk del --no-cache tzdata

# add zookeeper user
RUN sed -i -r 's/nofiles/zookeeper/' /etc/group && \
    adduser -u 200 -D -S -G zookeeper zookeeper



RUN apk add --no-cache wget bash su-exec \
    && mkdir /opt \
    && wget -q -O - http://apache.mirrors.pair.com/zookeeper/zookeeper-${ZK_VERSION}/zookeeper-${ZK_VERSION}.tar.gz | tar -xzf - -C /opt \
    && mv /opt/zookeeper-$ZK_VERSION /opt/zookeeper \
    && chown zookeeper.zookeeper /opt/zookeeper -R
    
ADD docker-entrypoint.sh /usr/bin/

RUN chmod +x /usr/bin/docker-entrypoint.sh

# install NodeNetPlugin cluster discovery program
RUN wget -O /usr/local/bin/NodeNetPlugin "https://github.com/goodrain/NodeNetPlugin/releases/download/${NODENET_VERSION}/NodeNetPlugin" && \
    chmod +x /usr/local/bin/NodeNetPlugin

COPY conf /opt/zookeeper/conf

EXPOSE 2181 2888 3888

WORKDIR /opt/zookeeper

VOLUME /data

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["start-foreground"]
