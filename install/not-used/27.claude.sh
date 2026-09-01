

if [ -f $AGENT_INFRA_DEV_TOOLS/claude/*claude* ]
then
	echo "You already have  $AGENT_INFRA_DEV_TOOLS/claude/*claude* "
	exit 0
fi

mkdir -p $AGENT_INFRA_DEV_TOOLS/claude

cd $AGENT_INFRA_DEV_TOOLS/claude

wget https://claude.ai/install.sh 
bash ./install.sh





