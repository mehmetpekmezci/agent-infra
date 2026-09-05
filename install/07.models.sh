#
if [ "$AGENT_INFRA_DIR" = "" ]
then
        echo "AGENT_INFRA_DIR environment variable not found ! "
        echo "Source the release file in the agent-infra directory !"
        exit 1
fi

pip3 install -U "huggingface_hub[cli]" --break-system-packages

mkdir -p $AGENT_INFRA_MODELS_DIR/$AGENT_INFRA_MODEL

if [ ! -f $AGENT_INFRA_MODELS_DIR/$AGENT_INFRA_MODEL/*.safetensors ]
then
    hf download "$AGENT_INFRA_MODEL" --local-dir $AGENT_INFRA_MODELS_DIR/$AGENT_INFRA_MODEL
fi

#if [ "$AGENT_INFRA_MODEL_TOKENIZER" != "" -a ! -f $AGENT_INFRA_MODELS_DIR/$AGENT_INFRA_MODEL/tokenizer/config.json ]
#then
#   
#   mkdir -p $AGENT_INFRA_MODELS_DIR/$AGENT_INFRA_MODEL/tokenizer
#   hf download "$AGENT_INFRA_MODEL_TOKENIZER" config.json --local-dir $AGENT_INFRA_MODELS_DIR/$AGENT_INFRA_MODEL/
#   hf download "$AGENT_INFRA_MODEL_TOKENIZER" tokenizer.json --local-dir $AGENT_INFRA_MODELS_DIR/$AGENT_INFRA_MODEL/tokenizer
#   hf download "$AGENT_INFRA_MODEL_TOKENIZER" tokenizer_config.json --local-dir $AGENT_INFRA_MODELS_DIR/$AGENT_INFRA_MODEL/tokenizer
##    hf download "$AGENT_INFRA_MODEL_HF_CONFIGS" generation_config.json --local-dir $AGENT_INFRA_MODELS_DIR/HF-CONFIG-$AGENT_INFRA_MODEL
#fi

echo
echo
echo ls $AGENT_INFRA_MODELS_DIR/$AGENT_INFRA_MODEL
ls $AGENT_INFRA_MODELS_DIR/$AGENT_INFRA_MODEL


