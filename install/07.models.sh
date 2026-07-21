#
if [ "$AGENT_INFRA_DIR" = "" ]
then
        echo "AGENT_INFRA_DIR environment variable not found ! "
        echo "Source the release file in the agent-infra directory !"
        exit 1
fi

pip3 install -U "huggingface_hub[cli]" --break-system-packages

mkdir -p $AGENT_INFRA_MODELS_DIR/$AGENT_INFRA_MODEL

if [ ! -f $AGENT_INFRA_MODELS_DIR/$AGENT_INFRA_MODEL/model.safetensors ]
then
    hf download $AGENT_INFRA_MODEL --local-dir $AGENT_INFRA_MODELS_DIR/$AGENT_INFRA_MODEL
fi

echo
echo
echo ls $AGENT_INFRA_MODELS_DIR/$AGENT_INFRA_MODEL
ls $AGENT_INFRA_MODELS_DIR/$AGENT_INFRA_MODEL


