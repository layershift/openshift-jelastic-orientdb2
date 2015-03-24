#!/bin/sh
#
# Copyright (c) Orient Technologies LTD (http://www.orientechnologies.com)
#

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
[ -f "$ORIENTDB2_HOME"/lib/orientdb-tools-2.0.5.jar ] || ORIENTDB2_HOME=`cd "$PRGDIR/.." ; pwd`
export ORIENTDB2_HOME
cd "$ORIENTDB2_HOME/bin"

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

"$JAVA" -client $JAVA_OPTS $ORIENTDB2_SETTINGS $SSL_OPTS -Dfile.encoding=utf-8 -Dorientdb.build.number="UNKNOWN@r${buildNumber}; 2015-03-12 22:59:10+0000" -cp "$ORIENTDB2_HOME/lib/orientdb-tools-2.0.5.jar:$ORIENTDB2_HOME/lib/*:$ORIENTDB_HOME/plugins/*" com.orientechnologies.orient.graph.console.OGremlinConsole $*
