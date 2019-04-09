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
echo "AD CONNECTIONPASSWORD"
read CONNECTIONPASSWORD
echo "Tomcat home: ${TOMCAT_HOME}"
echo "Base dir: ${BASEDIR}"


rm -rf WEB-INF

#
echo "Web context: "
read  WEB_CONTEXT
echo "OpenGrok port: "
read  OPENGROK_PORT
export SCRIPT_DIRECTORY=${BASEDIR}
export OPENGROK_TOMCAT_BASE="${TOMCAT_HOME}"
export OPENGROK_WEBAPP_CONTEXT="/${WEB_CONTEXT}"
export OPENGROK_DISTRIBUTION_BASE=$(realpath ${BASEDIR}/../lib)
export LOGGER_CONF_SOURCE="${SCRIPT_DIRECTORY}/../doc/logging.properties"
export OPENGROK_INSTANCE_BASE="$(realpath ${BASEDIR}/../../opengrok-${WEB_CONTEXT})"
export OPENGROK_WEBAPP_CFGADDR="localhost:${OPENGROK_PORT}"
if  [ -d "${OPENGROK_INSTANCE_BASE}" ]; then
    echo "INFO: Remove a previous ${OPENGROK_INSTANCE_BASE}"
    rm -rf $OPENGROK_INSTANCE_BASE
fi

echo "INFO: Make SRC_ROOT and DATA_ROOT directories"
mkdir -p ${OPENGROK_INSTANCE_BASE}/src
mkdir -p ${OPENGROK_INSTANCE_BASE}/etc
mkdir -p ${OPENGROK_INSTANCE_BASE}/data

TARGET_WAR="${BASEDIR}/../lib/${WEB_CONTEXT}.war"
if [ -f "${TARGET_WAR}" ]; then
    echo "INFO: Remove a previous ${TARGET_WAR}"
    rm -rf ${TARGET_WAR}
fi

echo "INFO: Change WEB-INF/web.xml in ${TARGET_WAR}"
cp $BASEDIR/../lib/source.war ${TARGET_WAR}
rm -rf work
mkdir work
cp -rv web/* work
pushd work
#jar xf ${TARGET_WAR} WEB-INF/web.xml
sed -i -e  "s|    <param-value>/var/opengrok/etc/configuration.xml</param-value>|    <param-value>${OPENGROK_INSTANCE_BASE}/etc/configuration.xml</param-value>|g" WEB-INF/web.xml
sed -i -e "s|2424|${OPENGROK_PORT}|g" WEB-INF/web.xml
sed -i -e "s|@CONNECTIONPASSWORD@|${CONNECTIONPASSWORD}|g" WEB-INF/web.xml
sed -i -e "s|@CONNECTIONPASSWORD@|${CONNECTIONPASSWORD}|g" META-INF/context.xml
jar uf ${TARGET_WAR} WEB-INF/web.xml
jar uf ${TARGET_WAR} *
popd
#echo "INFO: Change menu.jspf"
#jar xf ${TARGET_WAR}  menu.jspf
#sed -i -e "s|Math.min(6, |Math.min(20, |g" menu.jspf
#jar uf ${TARGET_WAR}  menu.jspf
#rm -rf menu.jspf*
#rm -rf WEB-INF*
echo "INFO: Get a sample project codes to a first indexing job"
pushd ${OPENGROK_INSTANCE_BASE}/src
if [ -z "${GIT_BRANCH}" ]; then
    echo "INFO: No sources"
else
    git clone -b ${GIT_BRANCH} ${REPO_URL} "$(basename ${REPO_URL})-${GIT_BRANCH//@}"
fi
popd
echo "INFO: WAIT..."
sleep 1

WEB_CONTEXT=${WEB_CONTEXT} OPENGROK_PORT=${OPENGROK_PORT} java \
-Djava.util.logging.config.file=${OPENGROK_INSTANCE_BASE}/logging.properties \
-jar $OPENGROK_DISTRIBUTION_BASE/opengrok.jar \
-W ${OPENGROK_INSTANCE_BASE}/etc/configuration.xml \
-s ${OPENGROK_INSTANCE_BASE}/src \
-d ${OPENGROK_INSTANCE_BASE}/data \
-U http://localhost:8080/$WEB_CONTEXT
-P -H -S -G -c /usr/local/bin/ctags

echo "INFO: Deploy a war file to Tomcat: ${TOMCAT_HOME}"
cp ${TARGET_WAR} ${TOMCAT_HOME}/webapps/
#WEB_CONTEXT=${WEB_CONTEXT} OPENGROK_PORT=${OPENGROK_PORT} $BASEDIR/OpenGrok deploy

echo "INFO: Wait for 1 seconds"
sleep 1
#WEB_CONTEXT=${WEB_CONTEXT} OPENGROK_PORT=${OPENGROK_PORT} $BASEDIR/OpenGrok index
echo "export OPENGROK_DISTRIBUTION_BASE=\"${OPENGROK_DISTRIBUTION_BASE}\"" > set_${WEB_CONTEXT}.sh
echo "export OPENGROK_INSTANCE_BASE=\"${OPENGROK_INSTANCE_BASE}\"" >> set_${WEB_CONTEXT}.sh
echo "export OPENGROK_PORT=\"${OPENGROK_PORT}\"" >> set_${WEB_CONTEXT}.sh
echo "export SCRIPT_DIRECTORY=\"${SCRIPT_DIRECTORY}\"" >> set_${WEB_CONTEXT}.sh
echo "export OPENGROK_WEBAPP_CONTEXT=\"${OPENGROK_WEBAPP_CONTEXT}\"" >> set_${WEB_CONTEXT}.sh
echo "export OPENGROK_WEBAPP_CFGADDR=\"${OPENGROK_WEBAPP_CFGADDR}\"" >> set_${WEB_CONTEXT}.sh
echo "export PATH=\"${SCRIPT_DIRECTORY}/bin:${PATH}\" ">> set_${WEB_CONTEXT}.sh
echo "alias update_projects=\"java -jar ${OPENGROK_DISTRIBUTION_BASE}/opengrok.jar -W ${OPENGROK_INSTANCE_BASE}/etc/configuration -s ${OPENGROK_INSTANCE_BASE}/src -d ${OPENGROK_INSTANCE_BASE}/data -P -U localhost:${OPENGROK_PORT} -w /${WEB_CONTEXT} -C -a on \"" >> set_${WEB_CONTEXT}.sh
cp set_${WEB_CONTEXT}.sh ${OPENGROK_INSTANCE_BASE}/

# Print information
echo ""
echo "INFO: Print variables"
echo "# Information "
echo "OPENGROK_DISTRIBUTION_BASE    = ${OPENGROK_DISTRIBUTION_BASE}"
echo "OPENGROK_INSTANCE_BASE        = $(realpath ${OPENGROK_INSTANCE_BASE})"
echo "OPENGROK_PORT                 = ${OPENGROK_PORT}"
echo "SCRIPT_DIRECTORY              = ${SCRIPT_DIRECTORY}"
echo "OPENGROK_WEBAPP_CONTEXT       = /${WEB_CONTEXT}"
echo "TOMCAT_HOME                   = ${TOMCAT_HOME}"

echo ""
echo "# Done"
set +x
