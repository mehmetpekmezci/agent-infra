#https://github.com/QuantumNous/new-api

export VLLM_API_KEY="your-custom-local-key"

mkdir -p $AGENT_INFRA_DATA_DIR/new_api

DOCKER_NAME=NEWAPI_0
sudo docker inspect $DOCKER_NAME &>/dev/null
if [ $? = 0 ]
then
    sudo docker start $DOCKER_NAME 
else

  #sudo docker run -d --name $DOCKER_NAME --network llm-net -p 3000:3000 -v ./data:/data -e TZ=America/New_York calciumion/new-api:latest
  # --restart always
  sudo docker run -d --name $DOCKER_NAME  -p 3000:3000 -v $AGENT_INFRA_DATA_DIR/new_api:/data -e TZ=$(timedatectl show --property=Timezone --value) -e REDIS_CONN_STRING="redis://:redis_password@host.docker.internal:6379"  -e SQL_DSN="postgresql://pguser:pgpassword@host.docker.internal:5432/pgdb?sslmode=disable" --add-host=host.docker.internal:host-gateway calciumion/new-api:latest

  # psql -h localhost -U pguser -d pgdb
  # password : pgpassword
  # if it does not work :
  # There is a chance that you changed the username/passwords after creating first container, so you have to clean the previous data and reconstruct new container with new user/pass.
  # docker container ls -a | grep POSTGRE_0 , using this commnad determine the container id , and with the command "sudo docker container rm -f <id>"  , stop and delete that container
  # rm -Rf  $AGENT_INFRA_DATA_DIR/pgdata
  # ./02.postgres.sh 

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

nvidia-smi
 
#sudo docker logs $DOCKER_NAME

