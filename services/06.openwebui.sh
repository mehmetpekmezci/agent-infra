mkdir -p $AGENT_INFRA_DATA_DIR/redis_data

sudo docker inspect REDIS_0 >/dev/null
if [ $? = 0 ]
then
    sudo docker start REDIS_0 
    #sudo docker container rm -f POSTGRE_0
else
    docker run -d --name REDIS_0 -p 6379:6379 -v $AGENT_INFRA_DATA_DIR/redis_data:/data --restart unless-stopped redis redis-server --appendonly yes --requirepass "your_strong_password" >& $AGENT_INFRA_LOG_DIR/redis.log &

    docker run -d \
  -p 3000:8080 \
  --add-host=host.docker.internal:host-gateway \
  -v open-webui:/app/backend/data \
  --name open-webui \
  --restart always \
  ghcr.io/open-webui/open-webui:main

fi

