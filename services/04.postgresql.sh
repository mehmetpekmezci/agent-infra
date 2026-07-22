mkdir -p $AGENT_INFRA_DATA_DIR/pgdata

sudo docker inspect POSTGRE_0 >/dev/null
if [ $? = 0 ]
then
    sudo docker start POSTGRE_0 
    #sudo docker container rm -f POSTGRE_0
else
    docker run --name POSTGRE_0 -e POSTGRES_USER=myuser -e POSTGRES_PASSWORD=mysecretpassword -e POSTGRES_DB=mydb -p 5432:5432 -v $AGENT_INFRA_DATA_DIR/pgdata:/var/lib/postgresql/data -d postgres:17 >& $AGENT_INFRA_LOG_DIR/postgre.log &
fi

