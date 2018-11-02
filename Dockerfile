FROM tomcat:7-jre7

MAINTAINER Mehmet Sirin Usanmaz <musanmaz@snapbytes.com>

ENV ARTIFACTORY_VERSION 3.9.4
ENV ARTIFACTORY_SHA1 e42ecd584a56fc14094548a408b61e5bc9bcac42

RUN rm -rf webapps/*

COPY urlrewrite/WEB-INF/lib/urlrewritefilter.jar /
COPY urlrewrite/WEB-INF/urlrewrite.xml /
RUN \
  mkdir -p webapps/ROOT/WEB-INF/lib && \
  mv /urlrewritefilter.jar webapps/ROOT/WEB-INF/lib && \
  mv /urlrewrite.xml webapps/ROOT/WEB-INF/

RUN \
  echo $ARTIFACTORY_SHA1 artifactory.zip > artifactory.zip.sha1 && \
  curl -L -o artifactory.zip https://bintray.com/artifact/download/jfrog/artifactory/artifactory-${ARTIFACTORY_VERSION}.zip && \
  sha1sum -c artifactory.zip.sha1 && \
  unzip -j artifactory.zip "artifactory-*/webapps/artifactory.war" -d webapps && \
  rm artifactory.zip

RUN echo 'export CATALINA_OPTS="$RUNTIME_OPTS"' > bin/setenv.sh

RUN mkdir -p /artifactory
ENV ARTIFACTORY_HOME /artifactory

VOLUME /artifactory/data
VOLUME /artifactory/logs
VOLUME /artifactory/backup

WORKDIR /artifactory
