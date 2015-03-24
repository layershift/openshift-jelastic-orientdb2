#!/bin/sh
#
# Copyright (c) 2014 Luca Garulli
#

#set current working directory
cd `dirname $0`

# resolve links - $0 may be a softlink
PRG="$0"

while [ -h "$PRG" ]; do
  ls=`ls -ld "$PRG"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '/.*' > /dev/null; then
    PRG="$link"
  else
    PRG=`dirname "$PRG"`/"$link"
  fi
done

# Get standard environment variables
PRGDIR=`dirname "$PRG"`

# Only set ORIENTDB2_HOME if not already set
[ -f "$ORIENTDB2_HOME"/lib/orientdb-etl-@VERSION@.jar ] || ORIENTDB2_HOME=`cd "$PRGDIR/.." ; pwd`
export ORIENTDB2_HOME

# Set JavaHome if it exists
if [ -f "${JAVA_HOME}/bin/java" ]; then 
   JAVA=${JAVA_HOME}/bin/java
else
   JAVA=java
fi
export JAVA

ORIENTDB2_SETTINGS="-Djava.util.logging.config.file="$ORIENTDB2_HOME/config/orientdb-client-log.properties" -Djava.awt.headless=true"
#JAVA_OPTS=-Xmx1024m
KEYSTORE=$ORIENTDB2_HOME/config/cert/orientdb-console.ks
KEYSTORE_PASS=password
TRUSTSTORE=$ORIENTDB2_HOME/config/cert/orientdb-console.ts
TRUSTSTORE_PASS=password
SSL_OPTS="-Xmx512m -Dclient.ssl.enabled=false -Djavax.net.ssl.keyStore=$KEYSTORE -Djavax.net.ssl.keyStorePassword=$KEYSTORE_PASS -Djavax.net.ssl.trustStore=$TRUSTSTORE -Djavax.net.ssl.trustStorePassword=$TRUSTSTORE_PASS"

$JAVA -server $JAVA_OPTS $ORIENTDB2_SETTINGS $SSL_OPTS -Dfile.encoding=utf-8 -Dorientdb.build.number="@BUILD@" -cp "$ORIENTDB2_HOME/lib/*" com.orientechnologies.orient.etl.OETLProcessor $*
