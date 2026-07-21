sudo docker stop $(sudo docker container ls -a | grep "vllm/vllm-openai:latest"| awk '{print $1}')



sudo docker run --runtime nvidia --gpus all \
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

WAIT_FOR_STARTUP=1

while [ $WAIT_FOR_STARTUP = 1 ]
do

      echo grep "Application startup complete" $AGENT_INFRA_LOG_DIR/vllm.log
      grep "Application startup complete" $AGENT_INFRA_LOG_DIR/vllm.log
      if [ $? = 0 ]
      then
	      WAIT_FOR_STARTUP=0
      fi
      
      sleep 5
done


echo "VLLM Process is started ..."

nvidia-smi


## max-model-len 32000 : context len is 32K
