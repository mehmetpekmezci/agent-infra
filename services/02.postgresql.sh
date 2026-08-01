DOCKER_NAME=POSTGRE_0

mkdir -p $AGENT_INFRA_DATA_DIR/pgdata

sudo docker inspect $DOCKER_NAME &>/dev/null
if [ $? = 0 ]
then
    sudo docker start $DOCKER_NAME  
    #sudo docker container rm -f $DOCKER_NAME 
else

    #docker run --name $DOCKER_NAME --restart=always  -e POSTGRES_USER=myuser -e POSTGRES_PASSWORD=mysecretpassword -e POSTGRES_DB=mydb -p 5432:5432 -v $AGENT_INFRA_DATA_DIR/pgdata:/var/lib/postgresql/data -d postgres:17 >& $AGENT_INFRA_LOG_DIR/postgre.log &
    # DISABLE restart=always
    #
    docker run --name $DOCKER_NAME -e POSTGRES_USER=pguser -e POSTGRES_PASSWORD=pgpassword -e POSTGRES_DB=pgdb -p 5432:5432 -v $AGENT_INFRA_DATA_DIR/pgdata:/var/lib/postgresql/data -d postgres:17 >& $AGENT_INFRA_LOG_DIR/postgre.log &
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


