#!/bin/bash
set -x
java \
-Xmx30g \
-Dorg.opensolaris.opengrok.history.Subversion="$(which svn)" \
-Dorg.opensolaris.opengrok.history.git="$(which git)" \
-Djava.util.logging.config.file=${OPENGROK_INSTANCE_BASE}/logging.properties \
-jar ${OPENGROK_DISTRIBUTION_BASE}/opengrok.jar \
-i */second_batch_js_heavy.* \
-i *.exe -i *.msi -i *.utf8 -i */glge-*js -i */chromium*/src/chrome/test -i */git.indirectionsymlink -i */git.indirectionsymlink/* -i */buildhistory -i */BUILD/buildstats/* -i */BUILD/cache/* -i */BUILD/log/* -i */BUILD/stamps/* -i */BUILD/sstate-control/* -i */BUILD/sysroots/* -i */python2.7/* -i *.done -i *.tar.* -i *.zip -i */git2* -i */git2/* -i */downloads/* -i */sstate-cache/* -i *.a -i *.so -i *.o -i *bus\/devices* -i *.ipk -i *.jar -i 'devices/*.0' -i '/temp/*' -i *.pyc -i *.pyo -i *.pyd -i .git -i */.git -i */temp -i __pycache__ -i */__pycache__  -i *toolchain* \
-m 256 \
-r on \
-W ${OPENGROK_INSTANCE_BASE}/etc/configuration.xml \
-P \
-s ${OPENGROK_INSTANCE_BASE}/src \
-d ${OPENGROK_INSTANCE_BASE}/data \
-U http://localhost:8080${OPENGROK_WEBAPP_CONTEXT}
set +x
