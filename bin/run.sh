#!/bin/bash
if [ -z "${BUILD_LAYER}" ]; then
	echo "ERROR: define BUILD_LAYER (git url )"
	exit 1
fi
set -x
BASEDIR=$(dirname "$0")
if [ ! -f "$(which realpath)" ]; then
	sudo apt-get install -y realpath 
	if [ ! "$?" = "0" ]; then
		echo "Error: Can't install realpath"
		exit
	fi
fi
BASEDIR=`realpath ${BASEDIR}`
TOMCAT_HOME=`dirname $(dirname $(which catalina.sh))`
if [ "${TOMCAT_HOME}" = "" ]; then
	echo "Cant' find 'catalina.sh'"
	echo "Enter Tomcat Home: "
	read  TOMCAT_HOME
else
	TOMCAT_HOME=`realpath ${TOMCAT_HOME}`
fi
echo "Tomcat home: ${TOMCAT_HOME}"
echo "Base dir: ${BASEDIR}"
echo "Web context: "
read  WEB_CONTEXT
echo "OpenGrok port: "
read  OPENGROK_PORT
rm -rf WEB-INF
export OPENGROK_TOMCAT_BASE="${TOMCAT_HOME}"
export OPENGROK_WEBAPP_CONTEXT="/${WEB_CONTEXT}"
export OPENGROK_DISTRIBUTIOIN_BASE=$(realpath ${BASEDIR}/..)
export OPENGROK_INSTANCE_BASE="${BASEDIR}/../../opengrok-${WEB_CONTEXT}"
rm -rf $OPENGROK_INSTANCE_BASE
mkdir -p ${OPENGROK_INSTANCE_BASE}/src
mkdir -p ${OPENGROK_INSTANCE_BASE}/data
rm -rf ${BASEDIR}/../lib/${WEB_CONTEXT}.war

TARGET_WAR="${BASEDIR}/../lib/${WEB_CONTEXT}.war"
cp $BASEDIR/../lib/source.war ${TARGET_WAR}
jar xf ${TARGET_WAR} WEB-INF/web.xml
sed -i -e  "s|    <param-value>/var/opengrok/etc/configuration.xml</param-value>|    <param-value>${OPENGROK_INSTANCE_BASE}/etc/configuration.xml</param-value>|g" WEB-INF/web.xml
sed -i -e "s|2424|${OPENGROK_PORT}|g" WEB-INF/web.xml
jar uf ${TARGET_WAR} WEB-INF/web.xml
cp ${TARGET_WAR} ${TOMCAT_HOME}/webapps/
#WEB_CONTEXT=${WEB_CONTEXT} OPENGROK_PORT=${OPENGROK_PORT} $BASEDIR/OpenGrok deploy
echo "Wait for 3 seconds"
sleep 3
pushd ${OPENGROK_INSTANCE_BASE}/src
if [ -z "${GIT_BRANCH}" ]; then
 echo "INFO: No sources"
else
 git clone -b ${GIT_BRANCH} ${BUILD_LAYER} "build-starfish-${GIT_BRANCH//@}"

fi
popd
echo "WAIT..."
sleep 3
WEB_CONTEXT=${WEB_CONTEXT} OPENGROK_PORT=${OPENGROK_PORT} $BASEDIR/OpenGrok index

echo "export OPENGROK_DISTRIBUTIOIN_BASE=\"${OPENGROK_DISTRIBUTIOIN_BASE}\"" >> set_${WEB_CONTEXT}.sh
echo "export OPENGROK_INSTANCE_BASE=\"${OPENGROK_INSTANCE_BASE}\"" >> set_${WEB_CONTEXT}.sh
echo "export OPENGROK_PORT=\"${OPENGROK_PORT}\"" >> set_${WEB_CONTEXT}.sh
echo "Done"
set +x
