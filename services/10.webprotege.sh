
if [ "$AGENT_INFRA_DIR" = "" ]
then
        echo "AGENT_INFRA_DIR environment variable not found ! "
        echo "Source the release file in the agent-infra directory !"
        exit 1
fi


### ONTOLOGY SERVER
#
DOCKER_NAME=WEB_PROTEGE_0

mkdir -p $AGENT_INFRA_DATA_DIR/web_protege_data

sudo docker inspect $DOCKER_NAME &>/dev/null
if [ $? = 0 ]
then
    sudo docker start $DOCKER_NAME  
else
    #sudo docker run --name $DOCKER_NAME --add-host=host.docker.internal:host-gateway -p 5000:8080 -e webprotege.mongodb.host=host.docker.internal -e webprotege.mongodb.auth.username=admin  -e webprotege.mongodb.auth.password=your_secure_password -e webprotege.mongodb.auth.source=admin -d protegeproject/webprotege:latest  >& $AGENT_INFRA_LOG_DIR/web_protege.log &
    sudo docker run --name $DOCKER_NAME --add-host=host.docker.internal:host-gateway -p 5000:8080 -e webprotege.mongodb.uri="mongodb://admin:your_secure_password@host.docker.internal:27017/admin?authSource=admin"  -d protegeproject/webprotege:latest  >& $AGENT_INFRA_LOG_DIR/web_protege.log &

fi

WAIT_FOR_STARTUP=1

while [ $WAIT_FOR_STARTUP = 1 ]
do
      sudo docker ps | grep $DOCKER_NAME
      if [ $? = 0 ]
      then
              WAIT_FOR_STARTUP=0
      fi

      sleep 5
done


echo "$DOCKER_NAME Process is started ..."


