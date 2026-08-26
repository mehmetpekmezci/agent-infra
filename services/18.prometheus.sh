
if [ "$AGENT_INFRA_DIR" = "" ]
then
        echo "AGENT_INFRA_DIR environment variable not found ! "
        echo "Source the release file in the agent-infra directory !"
        exit 1
fi


DOCKER_NAME=PROMETHEUS_0

mkdir -p $AGENT_INFRA_DATA_DIR/prometheus_data/configs
cp -f 18.prometheus.sh.prometheus.yml $AGENT_INFRA_DATA_DIR/prometheus_data/configs/prometheus.yml
chmod -Rf 777 $AGENT_INFRA_DATA_DIR/prometheus_data 

sudo docker inspect $DOCKER_NAME &>/dev/null
if [ $? = 0 ]
then
    sudo docker start $DOCKER_NAME  
else
    # DISABLE restart=always
    sudo docker run --name $DOCKER_NAME -p 9090:9090 -v $AGENT_INFRA_DATA_DIR/prometheus_data/:/prometheus/ -v $AGENT_INFRA_DATA_DIR/prometheus_data/configs/prometheus.yml:/etc/prometheus/prometheus.yml  -d ubuntu/prometheus:3.11-26.04_stable >& $AGENT_INFRA_LOG_DIR/prometheus.log &

    # prom/prometheus

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

echo "
DOCS : https://prometheus.io/docs/prometheus/latest/installation/ 
      

GOTO : http://localhost:9090 
No credentials 

"

