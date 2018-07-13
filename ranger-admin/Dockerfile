
FROM maven:3.5.3-jdk-8
#FROM openjdk:8u121-jdk

LABEL maintainer-twitter="@coheigea"
LABEL version=1.0.0

ARG RANGER_VERSION=1.0.0

ADD https://jdbc.postgresql.org/download/postgresql-42.2.1.jar /opt

ADD http://mirrors.whoishostingthis.com/apache/ranger/${RANGER_VERSION}/apache-ranger-${RANGER_VERSION}.tar.gz /opt

COPY ranger-entrypoint.sh /opt

WORKDIR /opt

RUN apt-get -q update && apt-get install -y -q python gcc \
 && tar zxvf apache-ranger-${RANGER_VERSION}.tar.gz \
 && cd apache-ranger-${RANGER_VERSION} \
 && mvn package assembly:assembly -DskipTests \
 && cp target/ranger-${RANGER_VERSION}-admin.tar.gz /opt \
 && cd /opt \
 && tar zxvf ranger-${RANGER_VERSION}-admin.tar.gz \
 && chmod +x /opt/ranger-entrypoint.sh

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
ENV RANGER_HOME=/opt/ranger-${RANGER_VERSION}-admin

COPY install.properties ${RANGER_HOME}

# Additions by DAP team to enable adding S3 policies
RUN apt-get install -y net-tools && \
    cd /tmp && \
    git clone https://github.com/bolkedebruin/rangers3plugin.git && \
    cd rangers3plugin && \
    mvn package -DskipTests && \
    mkdir -p ${RANGER_HOME}/ews/webapp/WEB-INF/classes/ranger-plugins/s3/ && \
    mv /tmp/rangers3plugin/target/ranger-s3-plugin-1.0-SNAPSHOT.jar ${RANGER_HOME}/ews/webapp/WEB-INF/classes/ranger-plugins/s3/ && \
    cd /root && \
    rm -rf /tmp/rangers3plugin

COPY ranger-servicedef-s3.json /tmp
COPY setup-ranger.sh /tmp
COPY entrypoint.sh /tmp

RUN chmod 777 -R /tmp

EXPOSE 6080

ENTRYPOINT ["sh", "-c", "/tmp/entrypoint.sh"]
