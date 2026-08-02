## https://github.com/vllm-project/vllm/releases
## you may also select a release from there and install the image by its version.


# sudo docker pull vllm/vllm-openai:v0.26.0
sudo docker pull vllm/vllm-openai:latest

sudo docker run --rm --entrypoint pip vllm/vllm-openai:latest show vllm
sudo docker inspect --format='{{index .Config.Labels "org.opencontainers.image.version"}}' vllm/vllm-openai:latest

echo
echo
echo
echo "#### DOCKER IMAGES LIST:"
echo
sudo docker image list


echo
echo
echo
echo "#### DOCKER CONTAINERS LIST:"
echo
sudo docker container list -a

# you may also delete using :
# sudo docker image rm "vllm/vllm-openai:latest"
#
