#!/bin/bash

if [ "$AGENT_INFRA_DIR" = "" ]
then
	echo "AGENT_INFRA_DIR environment variable not found ! "
	echo "Source the release file in the agent-infra directory !"
        exit 1
fi


cd $AGENT_INFRA_DIR/install


for installation_script in $(ls *.sh| grep -v _ | grep [0-9] | grep -v 00)
do
   echo
   echo
   echo "STARTED: $installation_script"
   echo
   echo
   bash $installation_script
   echo
   echo
   echo "FINISHED:  $installation_script"
   echo
   echo
done



