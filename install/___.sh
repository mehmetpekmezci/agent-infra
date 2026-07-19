## INSTALL DOCKER AND NVIDIA CONTAINER TOOLKIT
sudo apt-get update
sudo apt install docker.io docker-compose-v2
sudo usermod -aG docker $USER
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey |sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg 
curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list 
sudo apt-get install -y nvidia-container-toolkit

sudo mkdir -p /data/ollama/models

# BY LOOKING AT : https://github.com/ollama/ollama/releases
# GET THE LATEST OLLAMA VERSION
# BY THIS TIME, THE LATEST TAG VERSION IS "v0.21.2" , so we pull with the name "ollama/ollama:0.21.2"  ( CAUTION: "0.21.2"  NOT   "v0.21.2"  )

OLLAMA_VERSION=0.21.2
#MODEL_NAME=llama3
MODEL_NAME=smollm:135m

sudo docker pull ollama/ollama:$OLLAMA_VERSION

#sudo docker save ollama.$OLLAMA_VERSION.tar ollama/ollama:$OLLAMA_VERSION

#sudo chown $USER *.tar

#sudo docker container rm -f ollama/ollama:$OLLAMA_VERSION

#sudo docker image rm -f ollama/ollama:$OLLAMA_VERSION

#sudo docker load -i ollama.$OLLAMA_VERSION.tar

#sudo docker run -d --gpus=all -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama:$OLLAMA_VERSION


echo "
FROM ollama/ollama:$OLLAMA_VERSION
VOLUME /root/.ollama
# Pull the model during build and save to /root/.ollama
RUN ollama serve & sleep 5 && ollama pull $MODEL_NAME 
" > dockerfile

sudo docker build -t ollama-$OLLAMA_VERSION-$MODEL_NAME .


#sudo docker exec -it ollama ollama pull llama3

#sudo docker exec -it ollama ollama list

#sudo docker exec -it ollama ollama run llama3

sudo docker container stop ollama
sudo docker container rm ollama

sudo apt  install docker-compose

echo "
services:
  ollama:
    image: ollama-$OLLAMA_VERSION-$MODEL_NAME
    container_name: ollama
    volumes:
      - ollama_data:/root/.ollama
    ports:
      - "11434:11434"
    #   - gpus=all
    deploy:
      resources:
        reservations:
          devices:
          - driver: nvidia
            count: 1
            capabilities: [gpu]
    entrypoint: [ '/bin/bash', '-c', 'ollama serve & sleep 10 && ollama run $MODEL_NAME && wait' ]

  open-webui:
    image: ghcr.io/open-webui/open-webui:main
    container_name: open-webui
    volumes:
      - open-webui:/app/backend/data
    ports:
      - "3000:8080"
    environment:
      - OLLAMA_BASE_URL=http://ollama:11434
    depends_on:
      - ollama

volumes:
  ollama_data:
  open-webui:
" >  docker-compose.yml

sudo docker exec ollama nvidia-smi
sudo docker logs ollama

sudo systemctl restart docker

sudo docker-compose up -d


