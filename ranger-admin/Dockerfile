
FROM maven:3.5.4-jdk-8
#FROM openjdk:8u121-jdk

ARG RANGER_VERSION=1.1.0

RUN curl https://jdbc.postgresql.org/download/postgresql-42.2.1.jar -o /opt/postgresql-42.2.1.jar && \
    curl http://mirrors.whoishostingthis.com/apache/ranger/${RANGER_VERSION}/apache-ranger-${RANGER_VERSION}.tar.gz -o /opt/apache-ranger-${RANGER_VERSION}.tar.gz

COPY ranger-entrypoint.sh /opt
COPY pom.xml /opt

WORKDIR /opt

# TODO: Tried to do some cleanup here, but that removes some necessary plugins
RUN apt-get -q update && apt-get install -y -q python gcc \
 && apt-get autoclean \
 && tar zxvf apache-ranger-${RANGER_VERSION}.tar.gz \
 && rm -f apache-ranger-${RANGER_VERSION}.tar.gz \
 && cp pom.xml apache-ranger-${RANGER_VERSION} \
 && rm pom.xml \
 && cd apache-ranger-${RANGER_VERSION} \
 && mvn -e package assembly:assembly -DskipTests \
 && cp target/ranger-${RANGER_VERSION}-admin.tar.gz /opt \
#  && mvn clean \
 && cd /opt \
 && tar zxvf ranger-${RANGER_VERSION}-admin.tar.gz \
 && rm -f ranger-${RANGER_VERSION}-admin.tar.gz \
 && rm -rf apache-ranger-${RANGER_VERSION} \
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
    mvn clean && \
    cd /root && \
    rm -rf /tmp/rangers3plugin

COPY resources /tmp/resources
COPY setup-ranger.sh /tmp
COPY entrypoint.sh /tmp
COPY log4j.xml /opt/ranger-1.0.0-admin/ews/webapp/WEB-INF/log4j.xml
COPY log4j.properties /opt/ranger-1.0.0-admin/ews/webapp/WEB-INF/log4j.properties

RUN chmod 777 -R /tmp

EXPOSE 6080

ENTRYPOINT ["sh", "-c", "/tmp/entrypoint.sh"]
