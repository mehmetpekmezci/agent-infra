

if [ "$AGENT_INFRA_DIR" = "" ]
then
        echo "AGENT_INFRA_DIR environment variable not found ! "
        echo "Source the release file in the agent-infra directory !"
        exit 1
fi

#sudo docker run --rm --entrypoint pip vllm/vllm-openai show vllm

DOCKER_NAME=VLLM_0
sudo docker inspect $DOCKER_NAME &>/dev/null
if [ $? = 0 ]
then
    sudo docker start $DOCKER_NAME 
else
#sudo docker run --name $DOCKER_NAME --runtime nvidia --restart=always --gpus all \

echo sudo docker run --name $DOCKER_NAME --runtime nvidia --gpus all \
  -v $AGENT_INFRA_MODELS_DIR/$AGENT_INFRA_MODEL:/local_model \
  -p 8000:8000 \
  --ipc=host \
  --env "HF_HUB_OFFLINE=1" \
  --env "TRANSFORMERS_OFFLINE=1" \
  vllm/vllm-openaiv:0.26.0 \
  --model /local_model \
  --enable-auto-tool-choice --tool-call-parser $AGENT_INFRA_MODEL_TOOL_CALL_PARSER \
  --gpu-memory-utilization 0.85 \
  --dtype float16 \
  --kv-cache-memory=2919837389 \
  --max-model-len 32000 

sudo docker run --name $DOCKER_NAME --runtime nvidia --gpus all \
  -v $AGENT_INFRA_MODELS_DIR/$AGENT_INFRA_MODEL:/local_model \
  -p 8000:8000 \
  --ipc=host \
  --env "HF_HUB_OFFLINE=1" \
  --env "TRANSFORMERS_OFFLINE=1" \
  vllm/vllm-openai:v0.26.0 \
  --model /local_model \
  --enable-auto-tool-choice --tool-call-parser $AGENT_INFRA_MODEL_TOOL_CALL_PARSER \
  --gpu-memory-utilization 0.85 \
  --dtype float16 \
  --kv-cache-memory=2919837389 \
  --max-model-len 32000 >& $AGENT_INFRA_LOG_DIR/vllm.log &


#sudo docker run --name VLLM_0 --runtime nvidia --gpus all -v /home/atalet/workspace/agent-infra/models/Qwen/Qwen2.5-Coder-1.5B-Instruct:/local_model -p 8000:8000 --ipc=host --env HF_HUB_OFFLINE=1 --env TRANSFORMERS_OFFLINE=1 vllm/vllm-openai   --model /local_model  --enable-auto-tool-choice --tool-call-parser hermes --gpu-memory-utilization 0.85 --dtype float16 --max-model-len 32000



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

