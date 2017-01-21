#!/bin/sh

set -e

rsyslogd &

# Make sure world is owned by minecraft after backup restore
#chown -R $NB_USER:users $HOME/world

#start minecraft w/ user minecraft
su - $NB_USER -c "java -Xms1G -Xmx7G -d64 -jar forge-$VERSION-universal.jar"