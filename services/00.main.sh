#!/bin/bash

if [ "$AGENT_INFRA_DIR" = "" ]
then
	echo "AGENT_INFRA_DIR environment variable not found ! "
	echo "Source the release file in the agent-infra directory !"
        exit 1
fi


cd $AGENT_INFRA_DIR/services

mkdir -p $AGENT_INFRA_LOG_DIR


for start_script in $(ls *.sh| grep -v _ | grep [0-9] | grep -v 00)
do
   echo
   echo
   echo "RUNNING: $start_script"
   echo
   echo
   bash $start_script
done



