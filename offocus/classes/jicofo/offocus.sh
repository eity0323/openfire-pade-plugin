#!/bin/bash

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

mainClass="org.jitsi.jicofo.Main"
cp=$(JARS=($SCRIPT_DIR/jicofo*.jar $SCRIPT_DIR/lib/*.jar); IFS=:; echo "${JARS[*]}")
logging_config="$SCRIPT_DIR/lib/logging.properties"

# if there is a logging config file in lib folder use it (running from source)
if [ -f $logging_config ]; then
    LOGGING_CONFIG_PARAM="-Djava.util.logging.config.file=$logging_config"
fi

if [ -z "$JICOFO_MAX_MEMORY" ]; then JICOFO_MAX_MEMORY=3072m; fi

exec java -Xmx$JICOFO_MAX_MEMORY -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/tmp -Dnet.java.sip.communicator.SC_HOME_DIR_LOCATION=. -Dnet.java.sip.communicator.SC_HOME_DIR_NAME=. -Djdk.tls.ephemeralDHKeySize=2048 $LOGGING_CONFIG_PARAM $JAVA_SYS_PROPS -cp $cp $mainClass $@
