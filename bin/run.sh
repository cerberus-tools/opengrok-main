#!/bin/bash
function realpath() {
	python -c "import os; r = os.path.abspath('"$1"');print(r)"
}

if [ -z "${REPO_URL}" ]; then
    REPO_URL="https://github.com/hishamhm/htop"
	echo "ERROR: You don't define REPO_URL (git url )"
	echo "ERROR: Default = ${REPO_URL}"
fi

if [ -z "${GIT_BRANCH}" ]; then
    GIT_BRANCH="master"
fi

# Find the script's location
BASEDIR=$(dirname "$0")
BASEDIR=`realpath ${BASEDIR}`

# Find Tomcat's location
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

#
echo "Web context: "
read  WEB_CONTEXT
echo "OpenGrok port: "
read  OPENGROK_PORT
rm -rf WEB-INF
export OPENGROK_TOMCAT_BASE="${TOMCAT_HOME}"
export OPENGROK_WEBAPP_CONTEXT="/${WEB_CONTEXT}"
export OPENGROK_DISTRIBUTIOIN_BASE=$(realpath ${BASEDIR}/../lib)
export OPENGROK_INSTANCE_BASE="${BASEDIR}/../../opengrok-${WEB_CONTEXT}"
export SCRIPT_DIRECTORY=$(realpath ${BASEDIR}/../)
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
    git clone -b ${GIT_BRANCH} ${REPO_URL} "$(basename ${REPO_URL})-${GIT_BRANCH//@}"
fi
popd
echo "WAIT..."
sleep 3
WEB_CONTEXT=${WEB_CONTEXT} OPENGROK_PORT=${OPENGROK_PORT} $BASEDIR/OpenGrok index

echo "export OPENGROK_DISTRIBUTIOIN_BASE=\"${OPENGROK_DISTRIBUTIOIN_BASE}\"" >> set_${WEB_CONTEXT}.sh
echo "export OPENGROK_INSTANCE_BASE=\"${OPENGROK_INSTANCE_BASE}\"" >> set_${WEB_CONTEXT}.sh
echo "export OPENGROK_PORT=\"${OPENGROK_PORT}\"" >> set_${WEB_CONTEXT}.sh
echo "export SCRIPT_DIRECTORY=\"${SCRIPT_DIRECTORY}\"" >> set_${WEB_CONTEXT}.sh
echo "export OPENGROK_WEBAPP_CONTEXT=\"${WEB_CONTEXT}\"" >> set_${WEB_CONTEXT}.sh
echo "export PATH=\"${SCRIPT_DIRECTORY}/bin:${PATH}\" ">> set_${WEB_CONTEXT}.sh
cp set_${WEB_CONTEXT}.sh ${OPENGROK_INSTANCE_BASE}/

# Print information
echo ""
echo "# Information "
echo "OPENGROK_DISTRIBUTIOIN_BASE   = ${OPENGROK_DISTRIBUTIOIN_BASE}"
echo "OPENGROK_INSTANCE_BASE        = $(realpath ${OPENGROK_INSTANCE_BASE})"
echo "OPENGROK_PORT                 = ${OPENGROK_PORT}"
echo "SCRIPT_DIRECTORY              = ${SCRIPT_DIRECTORY}"
echo "OPENGROK_WEBAPP_CONTEXT       = /${WEB_CONTEXT}"
echo "TOMCAT_HOME                   = ${TOMCAT_HOME}"

echo ""
echo "# Done"
set +x
