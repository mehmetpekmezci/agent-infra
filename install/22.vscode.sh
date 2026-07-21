
if [ ! -d $AGENT_INFRA_DEV_TOOLS/VSCode-linux-x64 ]
then

  if [ ! -f code-stable-x64-1784303500.tar.gz ]
  then
    wget https://vscode.download.prss.microsoft.com/dbazure/download/stable/8a7abeba6e03ea3af87bfbce9a1b7e48fed567b8/code-stable-x64-1784303500.tar.gz
  fi

  if [ ! -d VSCode-linux-x64 ]
  then
    tar xf code-stable-x64-1784303500.tar.gz
  fi

  mkdir -p $AGENT_INFRA_DEV_TOOLS

  mv VSCode-linux-x64 $AGENT_INFRA_DEV_TOOLS

fi

echo ls $AGENT_INFRA_DEV_TOOLS/VSCode-linux-x64
ls $AGENT_INFRA_DEV_TOOLS/VSCode-linux-x64

echo "./code --no-sandbox" > $AGENT_INFRA_DEV_TOOLS/VSCode-linux-x64/code.sh





