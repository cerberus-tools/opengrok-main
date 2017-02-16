# How to index only one project 

java -jar ~/program/opengrok-main/lib/opengrok.jar  -W ~/program/opengrok-opengrok-testapp/etc/configuration.xml -s ~/program/opengrok-opengrok-testapp/src -d ~/program/opengrok-opengrok-testapp/data/ -P -U localhost:1905 -w /opengrok-testapp -C -a on /starfish-luna-surface-manager

READ_XML_CONFIGURATION=/vol/users/gatekeeper.tvsw/program/opengrok-opengrok-testapp/etc/configuration.xml OpenGrok indexpart /vol/users/gatekeeper.tvsw/program/opengrok-opengrok-testapp/src /starfish-luna-surface-manager

