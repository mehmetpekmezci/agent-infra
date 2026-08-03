
if [ "$AGENT_INFRA_DIR" = "" ]
then
        echo "AGENT_INFRA_DIR environment variable not found ! "
        echo "Source the release file in the agent-infra directory !"
        exit 1
fi


DOCKER_NAME=MONGO_0

mkdir -p $AGENT_INFRA_DATA_DIR/mongo_data

sudo docker inspect $DOCKER_NAME &>/dev/null
if [ $? = 0 ]
then
    sudo docker start $DOCKER_NAME  
else

    # DISABLE restart=always
    sudo docker run --name $DOCKER_NAME -e MONGO_INITDB_ROOT_USERNAME=admin  -e MONGO_INITDB_ROOT_PASSWORD=your_secure_password  -p 27017:27017 -v $AGENT_INFRA_DATA_DIR/mongo_data:/data/db -d mongo:latest >& $AGENT_INFRA_LOG_DIR/mongo.log &

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


