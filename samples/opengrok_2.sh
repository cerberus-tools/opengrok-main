 /usr/local/jdk/jdk1.8.0_102/bin/java
 -Xmx2048m
 -Dorg.opensolaris.opengrok.history.Subversion=/usr/bin/svn
 -Dorg.opensolaris.opengrok.history.git=/usr/bin/git
 -Djava.util.logging.config.file=/home/work/gatekeeper.tvsw/program/opengrok-main/bin/../../opengrok-opengrok-starfish-deua/logging.properties
 -jar /home/work/gatekeeper.tvsw/program/opengrok-main/bin/../lib/opengrok.jar
 -r on
 -c /usr/bin/ctags-exuberant
 -a on
 -R /vol/users/gatekeeper.tvsw/program/opengrok-opengrok-starfish-deua/etc/configuration.xml
 -h /build-starfish-drd4tv /build-starfish-drd4tv



java \
-Xms100g \
-Xmx110g \
-XX:+HeapDumpOnOutOfMemoryError \
-Dcom.sun.management.jmxremote.port=1997 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false \
-Dorg.opensolaris.opengrok.history.Subversion=/usr/bin/svn \
-Dorg.opensolaris.opengrok.history.git=/usr/bin/git \
-Djava.util.logging.config.file=${OPENGROK_INSTANCE_BASE}/logging.properties \
-jar ${OPENGROK_DISTRIBUTION_BASE}/opengrok.jar \
-i */git.indirectionsymlink -i */git.indirectionsymlink/* -i */buildhistory -i */BUILD/buildstats/* -i */BUILD/cache/* -i */BUILD/log/* -i */BUILD/stamps/* -i */BUILD/sstate-control/* -i */BUILD/sysroots/* -i */python2.7/* -i *.done -i *.tar.* -i *.zip -i */git2* -i */git2/* -i */downloads/* -i */sstate-cache/* -i *.a -i *.so -i *.o -i *bus\/devices* -i *.ipk -i *.jar -i 'devices/*.0' -i '/temp/*' -i *.pyc -i *.pyo -i *.pyd -i .git -i */.git -i */temp -i __pycache__ -i */__pycache__  -i *toolchain* \
-m 256 \
-r on \
-c /usr/bin/ctags-exuberant \
-a on \
-W ${OPENGROK_INSTANCE_BASE}/etc/configuration.xml \
-S \
-P \
-U localhost:2001 \
-w ${OPENGROK_WEBAPP_CONTEXT} \
-s $(pwd) \
-d ${OPENGROK_INSTANCE_BASE}/data \
-H \
-C \
-h /${PROJECT_NAME} /${PROJECT_NAME}
