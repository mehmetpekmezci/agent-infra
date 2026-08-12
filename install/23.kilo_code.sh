## KILO CODE VERION IS : 7.4.20
#
mkdir -p $AGENT_INFRA_DEV_TOOLS/kilo-code

cd $AGENT_INFRA_DEV_TOOLS/kilo-code

#curl -fsSL https://kilo.ai/cli/install | bash
#curl -fsSL https://kilo.ai/cli/install 
wget https://kilo.ai/cli/install 

chmod +x install

./install


echo "
KILO CODE command line tool is installed.

If you also want to install kilo-code extyension of vscode, please follow these instructions :

1. Start VSCode : cd $AGENT_INFRA_DEV_TOOLS/dev-tools/VSCode-linux-x64; ./code.sh

2. Press Ctrl-Shift-x  

3. Write 'kilo code' into the filtering text field which is found on the left - top of the VSCode.

4. Click install on the extension which has 'Kilo Code : AI Coding agent that generates code from natural language ......'

5. The Kilo Code icon will appear on the left bar of the VSCode.
"







