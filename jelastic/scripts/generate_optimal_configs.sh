#!/bin/bash -x

SED=$(which sed);

#
# config optimizer for neo4j
#

ORIENTDB_RUN_SCRIPT="${OPENSHIFT_ORIENTDB_DIR}/versions/2.0.5/bin/server.sh";

 [ -z "$XMS" ] && { XMS=32m; }
 memory_total=`free -m | grep Mem | awk '{print $2}'`;
 [ -z "$XMX" ] && { let XMX=memory_total-35; XMX="${XMX}m";  }

$SED -i "s/-Xmx\([0-9]*[mM]\)*/-Xmx${XMX}/" $ORIENTDB_RUN_SCRIPT;
$SED -i "s/-Xms\([0-9]*[mM]\)*/-Xms${XMS}/" $ORIENTDB_RUN_SCRIPT;
