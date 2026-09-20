if [ "$AGENT_INFRA_DIR" = "" ]
then
	echo "no AGENT_INFRA_DIR env. var. found. Please source the 'release' file found in the parent directory of this script (agent-infra/release)"
	exit 1
fi

echo "Applying $AGENT_INFRA_DIR/harness to this directory ..."

mkdir -p .kilo

for dir in modes-agents workflows-commands skills-skills
do
	agent_infra_harness=$(echo $dir | cut -d- -f1)
	kilo_harness=$(echo $dir | cut -d- -f2)
	echo "Mapping files in the agent-infra harness directory : $agent_infra_harness TO the  kilo harness directory : $kilo_harness ...." 
        for sub in $AGENT_INFRA_DIR/harness/$agent_infra_harness/*
        do       
            f=$(basename $sub)
	    mkdir -p .kilo/$kilo_harness
            ln -s $sub .kilo/$kilo_harness/$f
        done
done
