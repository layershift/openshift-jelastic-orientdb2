#!/bin/sh
#
# Copyright (c) Orient Technologies LTD (http://www.orientechnologies.com)
#

echo "           .                                          "
echo "          .\`        \`                                 "
echo "          ,      \`:.                                  "
echo "         \`,\`    ,:\`                                   "
echo "         .,.   :,,                                    "
echo "         .,,  ,,,                                     "
echo "    .    .,.:::::  \`\`\`\`                                 :::::::::     :::::::::   "
echo "    ,\`   .::,,,,::.,,,,,,\`;;                      .:    ::::::::::    :::    :::  "
echo "    \`,.  ::,,,,,,,:.,,.\`  \`                       .:    :::      :::  :::     ::: "
echo "     ,,:,:,,,,,,,,::.   \`        \`         \`\`     .:    :::      :::  :::     ::: "
echo "      ,,:.,,,,,,,,,: \`::, ,,   ::,::\`   : :,::\`  ::::   :::      :::  :::    :::  "
echo "       ,:,,,,,,,,,,::,:   ,,  :.    :   ::    :   .:    :::      :::  :::::::     "
echo "        :,,,,,,,,,,:,::   ,,  :      :  :     :   .:    :::      :::  :::::::::   "
echo "  \`     :,,,,,,,,,,:,::,  ,, .::::::::  :     :   .:    :::      :::  :::     ::: "
echo "  \`,...,,:,,,,,,,,,: .:,. ,, ,,         :     :   .:    :::      :::  :::     ::: "
echo "    .,,,,::,,,,,,,:  \`: , ,,  :     \`   :     :   .:    :::      :::  :::     ::: "
echo "      ...,::,,,,::.. \`:  .,,  :,    :   :     :   .:    :::::::::::   :::     ::: "
echo "           ,::::,,,. \`:   ,,   :::::    :     :   .:    :::::::::     ::::::::::  "
echo "           ,,:\` \`,,.                                  "
echo "          ,,,    .,\`                                  "
echo "         ,,.     \`,                                          GRAPH DATABASE  "
echo "       \`\`        \`.                                                          "
echo "                 \`\`                                         www.orientdb.org "
echo "                 \`                                    "

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
[ -f "$ORIENTDB2_HOME"/bin/server.sh ] || ORIENTDB2_HOME=`cd "$PRGDIR/.." ; pwd`
export ORIENTDB2_HOME
cd "$ORIENTDB2_HOME/bin"

if [ ! -f "${CONFIG_FILE}" ]
then
  CONFIG_FILE=$ORIENTDB2_HOME/config/orientdb-server-config.xml
fi

# Raspberry Pi check (Java VM does not run with -server argument on ARMv6)
if [ `uname -m` != "armv6l" ]; then
  JAVA_OPTS="$JAVA_OPTS -server "
fi
export JAVA_OPTS

# Set JavaHome if it exists
if [ -f "${JAVA_HOME}/bin/java" ]; then 
   JAVA=${JAVA_HOME}/bin/java
else
   JAVA=java
fi
export JAVA

LOG_FILE=$ORIENTDB2_HOME/config/orientdb-server-log.properties
WWW_PATH=$ORIENTDB2_HOME/www
ORIENTDB2_SETTINGS="-Dprofiler.enabled=true"
JAVA_OPTS_SCRIPT="-Djna.nosys=true -XX:+HeapDumpOnOutOfMemoryError -Djava.awt.headless=true -Dfile.encoding=UTF8 -Drhino.opt.level=9"

# ORIENTDB MAXIMUM HEAP. USE SYNTAX -Xmx<memory>, WHERE <memory> HAS THE TOTAL MEMORY AND SIZE UNIT. EXAMPLE: -Xmx512m
MAXHEAP=-Xmx512m
# ORIENTDB MAXIMUM DISKCACHE IN MB, EXAMPLE, ENTER -Dstorage.diskCache.bufferSize=8192 FOR 8GB
MAXDISKCACHE=""

exec "$JAVA" $JAVA_OPTS $MAXHEAP $JAVA_OPTS_SCRIPT $ORIENTDB2_SETTINGS $MAXDISKCACHE -Djava.util.logging.config.file="$LOG_FILE" -Dorientdb.config.file="$CONFIG_FILE" -Dorientdb.www.path="$WWW_PATH" -Dorientdb.build.number="UNKNOWN@r${buildNumber}; 2015-03-12 22:59:10+0000" -cp "$ORIENTDB2_HOME/lib/orientdb-server-2.0.5.jar:$ORIENTDB2_HOME/lib/*" $* com.orientechnologies.orient.server.OServerMain
