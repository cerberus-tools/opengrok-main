 java
 -Xmx2048m
 -Dorg.opensolaris.opengrok.history.Subversion=$(which svn)
 -Dorg.opensolaris.opengrok.history.git=$(which git)
 -Djava.util.logging.config.file=${OPENGROK_INSTANCE_BASE}/logging.properties
 -jar ${OPENGROK_DISTRIBUTION_BASE}/opengrok.jar
 -r on
 -U localhost:${OPENGROK_PORT}
 -a on
 -R ${OPENGROK_INSTANCE_BASE}/etc/configuration.xml
 -h /${PROJECT_NAME} /${PROJECT_NAME}


