mkdir -p $AGENT_INFRA_DATA_DIR/redis_data

sudo docker inspect REDIS_0 >/dev/null
if [ $? = 0 ]
then
    sudo docker start REDIS_0 
    #sudo docker container rm -f POSTGRE_0
else
    docker run -d --name REDIS_0 -p 6379:6379 -v $AGENT_INFRA_DATA_DIR/redis_data:/data --restart unless-stopped redis redis-server --appendonly yes --requirepass "your_strong_password" >& $AGENT_INFRA_LOG_DIR/redis.log &
fi

