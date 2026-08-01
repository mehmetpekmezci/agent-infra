
DOCKER_NAME=VLLM_0
sudo docker inspect $DOCKER_NAME &>/dev/null
if [ $? = 0 ]
then
    sudo docker start $DOCKER_NAME 
else
#sudo docker run --name $DOCKER_NAME --runtime nvidia --restart=always --gpus all \
sudo docker run --name $DOCKER_NAME --runtime nvidia --gpus all \
  -v $AGENT_INFRA_MODELS_DIR/$AGENT_INFRA_MODEL:/local_model \
  -p 8000:8000 \
  --ipc=host \
  --env "HF_HUB_OFFLINE=1" \
  --env "TRANSFORMERS_OFFLINE=1" \
  vllm/vllm-openai:latest \
  --model /local_model \
  --gpu-memory-utilization 0.85 \
  --dtype float16 \
  --max-model-len 32000 >& $AGENT_INFRA_LOG_DIR/vllm.log &

  ## max-model-len 32000 : context len is 32K

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

