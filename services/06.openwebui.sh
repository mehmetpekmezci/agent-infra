DOCKER_NAME=OPEN_WEB_UI_0

mkdir -p $AGENT_INFRA_DATA_DIR/open_web_ui_data

sudo docker inspect $DOCKER_NAME &>/dev/null
if [ $? = 0 ]
then
    sudo docker start $DOCKER_NAME
    #sudo docker container rm -f $DOCKER_NAME
else
    #docker run -d -p 3000:8080 --add-host=host.docker.internal:host-gateway -v $AGENT_INFRA_DATA_DIR/open_web_ui_data:/app/backend/data --name $DOCKER_NAME --restart always ghcr.io/open-webui/open-webui:main
    #docker run -d -p 8080:8080 --add-host=host.docker.internal:host-gateway -e OPENAI_API_BASE_URL=http://host.docker.internal:8000/v1 -v $AGENT_INFRA_DATA_DIR/open_web_ui_data:/app/backend/data --name $DOCKER_NAME --restart always ghcr.io/open-webui/open-webui:main
    ## connect to new_api, not vllm. also disable restart always
    docker run -d -p 8080:8080 --add-host=host.docker.internal:host-gateway -e OPENAI_API_BASE_URL=http://host.docker.internal:3000/v1 -v $AGENT_INFRA_DATA_DIR/open_web_ui_data:/app/backend/data --name $DOCKER_NAME  ghcr.io/open-webui/open-webui:main



fi

