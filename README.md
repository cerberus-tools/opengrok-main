# opengrok-main
Make a opengrok instance with a independent web context path 

## What to do
1. Make a new :open_file_folder:**OPENGROK_INSTANCE_BASE** folder for a web context
  1. Sub folders
    1. :open_file_folder:**OPENGROK_INSTANCE_BASE/src**
    1. :open_file_folder:**OPENGROK_INSTANCE_BASE/data**    
1. Make a web application file witch a web context and :open_file_folder:**OPENGROK_INSTANCE_BASE** location
1. Deploy an web app to TOMCAT
1. If you define :pencil2:*$GIT_BRANCH* and :pencil2:*$GIT_URL*, clone it under :open_file_folder:**OPENGROK_INSTANCE_BASE/src** and create indexed data

## Make a OpenGrok instance with a web application name.
1. Clone this project into a local. Set it as :open_file_folder:**SCRIPT_DIRECTORY**
1. Add Tomcat's :open_file_folder:**bin** folder's absolute path to :pencil2:*$PATH*
1. Run :pencil:**$SCRIPT_DIRECTORY/bin/run.sh**
  * If you need some files, please write it on a file and set it with **OPENGROK_CONFIGURATION**
  * run.conf
  ```shell
  IGNORE_PATTERNS="-i .git -i */downloads -i */temp/*.i"
  OPENGROK_FLUSH_RAM_BUFFER_SIZE="-m 256 -T 120"
  ```
    * Command
  ```shell
  OPENGROK_CONFIGURATION=./run.conf $SCRIPT_DIRECTORY/bin/run.sh
  ```
1. Check a web app's url on a browser

## Install a OpenGrok instance from an OpenGrok's official released distribution
1. Install latest JDK 1.8 and add its 'bin' to $PATH
1. Install Tomcat 8.0.X 
  1. Go to http://tomcat.apache.org/download-80.cgi
  1. Download **8.0.x > Core > a distribution file( For examples .'tar.gz')**
  1. Unpack a zipped file into a local and set it as **$TOMCAT_HOME**
  1. Add **$TOMCAT_HOME/bin** to **$PATH**
1. Download OpenGrok's latest stable release from https://github.com/OpenGrok/OpenGrok/releases
1. Unpack a zipped file into a local and set it as **SCRIPT_DIRECTORY**
1. Set **OPENGROK_DISTRIBUTION_BASE==$SCRIPT_DIRECTORY/lib**
1. Decide **OPENGROK_INSTANCE_BASE**
1. Create **$OPENGROK_INSTANCE_BASE**, **$OPENGROK_INSTANCE_BASE/src**, **$OPENGROK_INSTANCE_BASE/data**
1. Go to **$SCRIPT_DIRECTORY**
1. Extract a WEB-INF/web.xml from a :pencil2:lib/source.war*** 
  ```
  Sunjoo:opengrok-0.12.1.6 sunjoo$ jar xf lib/source.war WEB-INF/web.xml
  Sunjoo:opengrok-0.12.1.6 sunjoo$ ls
  WEB-INF	bin	doc	lib	man
  Sunjoo:opengrok-0.12.1.6 sunjoo$ ls WEB-INF/web.xml
  WEB-INF/web.xml
  Sunjoo:opengrok-0.12.1.6 sunjoo$
  ```
1. Change configuration file's directory name to $OPENGROK_INSTANCE_BASE/etc
  * Old: ```<param-value>/var/opengrok/etc/configuration.xml</param-value>```
  * New: ```<param-value>/Users/sunjoo/temp/opengrok-instance/etc/configuration.xml</param-value>```
1. Change web app's PORT to a new port number if you have been using it for another service
  * Old: ```<param-value>localhost:2424</param-value>```
  * New: ```<param-value>localhost:2011</param-value>```
1. Change a port number '2424' to a new number in $SCRIPT_DIRECTORY/bin/OpenGrok if you change it
  * Old: ```WEBAPP_CONFIG_ADDRESS="localhost:2424"```
  * New: ```WEBAPP_CONFIG_ADDRESS="localhost:2011"```
1. Update :pencil2:**WEB-INF/web.xml** in :pencil2:**lib/source.war**
  ```
  Sunjoo:opengrok-0.12.1.6 sunjoo$ jar uf lib/source.war WEB-INF/web.xml
  ```
1. Make **$OPENGROK_INSTANCE_BASE/src** and **$OPENGROK_INSTANCE_BASE/data**
1. Run a deploy 
  ```
  $SCRIPT_DIRECTORY/bin/OpenGrok deploy
  ```
1. Unpack an archived sources under **$OPENGROK_INSTANCE_BASE/src**
  ```
  Sunjoo:opengrok-0.12.1.6 sunjoo$ pushd $OPENGROK_INSTANCE_BASE/src
  Sunjoo:src sunjoo$ cp -r ~/Downloads/apache-tomcat-8.0.33.tar .
  Sunjoo:src sunjoo$ tar xvf apache-tomcat-8.0.33.tar
  Sunjoo:src sunjoo$ popd
  ```
1. Run an indexingf job.
  ```
  $SCRIPT_DIRECTORY/bin/OpenGrok deploy
  ```