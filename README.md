# agent-infra

Agent-infra repository contains scripts, descriptions and example use cases of a local/offline/air-gapped agentic development environment.

In this repository we describe: 
1. Architecture Design Records about tool/service choices among other alternatives.
2. Simple usage example of each tool/service individually.
3. Usage of these tools/services in a full cycle development scenario.

ATTENTION: 
1. After cloning this repository, source the release file found in the repository before running any script .
2. "Start scripts" in services directory only triggers the existing container if it exists. If you change anything in the script, you should remove the container. ( E.g :  sudo docker rm -f VLLM_0; cd services;./01.vllm.sh)


| Component | Type | Description |
| --------- | ---- | ----------- | 
| VLLM | SERVICE | LLM Inference Engine | 
| New API | SERVICE | LLM Proxy ( AI model gateway) | 
| N8N | SERVICE | n8n is a web based workflow automation platform that uniquely combines AI capabilities with business process automation | 
| NE04J | SERVICE | Neo4j is a native graph DB | 
| Apache Jena Fuseki | SERVICE | To Serve Ontology Files| 
| Qdrant | SERVICE | Vector DB| 
| GraphRAG (Tigergraph) | SERVICE | GraphRAG (Graph Retrieval-Augmented Generation) enhances traditional RAG by embedding knowledge graphs into the LLM inference process. |
| Protege | TOOL | Ontology Development Tool | 
| Okf Harness| TOOL | an independent, open-source, terminal-native tool designed to help AI coding agents maintain local knowledge bases using Google’s Open Knowledge Format (OKF) | 
| Obsidian | TOOL | Obsidian is a popular note-taking and knowledge-management application that stores files as plain text Markdown documents on your local device| 
| Open Wiki | TOOL | OpenWiki is an open-source command-line interface (CLI) tool built by LangChain designed to write and automatically maintain structured Markdown documentation for codebases using LLM agents. |
| Deep Seek Harness | TOOL | an open-source, MIT-licensed agent runtime and framework developed by DeepSeek AI that wraps a large language model (LLM) with the tools, memory, sandboxes, and loop control needed to operate as an autonomous coding and task agent| 
| Kilo-Code CLI | TOOL | An open source agentic command-line coding tool  | 
| Graphify | TOOL | an open-source tool and AI coding-assistant skill that turns a project's files—including code, documentation, PDFs, images, and videos—into a queryable knowledge graph | 
| Caveman | TOOL | Installed within Coding Agents. This tool reduces tokens before sanding to inference service |
| RTK | TOOL | Rust Token Killer is a command-line proxy sitting between your AI agent and the shell that intercepts verbose outputs (like git log) and returns clean, deduplicated, and condensed text |
| Ponytail | TOOL | It pushes the agent to reuse existing code, platform features, and dependencies before writing anything new. |



## Hardware and OS Requirements to Run This Environment:
	
1.  A computer with a NVIDIA GPU that is supported by VLLM 

    For the list of GPUs supported by VLLM : https://docs.vllm.ai/en/stable/getting_started/installation/gpu/#requirements

    For the GPU size calculation : https://www.digitalocean.com/community/conceptual-articles/vllm-gpu-sizing-configuration-guide

2.  Ubuntu 24.04

3.  Sudo authorization in the operating system.

4.  100GB of disk space

##  Architecture Design Records

Architecture design records about :

1. Why we choose VLLM : [VLLM_ADR](docs/adrs/adr-001-ineference-engine-vllm.md)
2. Why we choose kilo-code among other coding assistants : [CODING_ASSISTANTS](docs/adrs/adr-002-ai-assistants.md)
3. How we use deep seek harness and kilo-code: [DEEP_SEEK_HARNESS_USAGE](docs/adrs/adr-003-deepseek-harness.md)
4. How we use Plugins/APIs and MCPs : [MCP_and_HARNESS](docs/adrs/aadr-004-mcp-vs-plugins.md)
5. How we do context token reduction :  [CONTEXT_TOKEN_REDUCTION](docs/adrs/adr-005-context-token-reduction-tools.md)


##  Installation of Services and Tools 

Installation scripts can be found in "install" directory. After cloning this repository, source the release file, go to intall directory and run "00.main.sh" to start installing services and tools. 
    
##  Starting Services

After installing services and tools, we start our services using the "services/00.main.sh" script which triggers other start scripts in this directory.

##  Usage

After starting the services, we are ready to use agentic tools. 

### 1. Simple Rust Development With One Agent
#### 1.1. Prepare Work Directory and Github Repository
	mkdir -p ~/agentspace
	cd ~/agentspace
	git clone git@github.com:mehmetpekmezci/agent-managed-rust-project.git
#### 1.2. CODE GENERATION
	source ~sdk/rust-dev-env/release
	source ~/workspace/agent-infra/release
	cd ~/agentspace/agent-managed-rust-project
	## NOTE: WE USE CTRL-INSERT TO PASTE TEXT.
	kilo
		> create a rust project with name simple_calculator
		> implement a simple calculator in main.rs . main.rs reads first value, math operator, second value as float value from terminal and performs the operation and prints the result.
		> run the main and feed the values 5 + 2 if interactive.
		> commit all source codes in simple_calculator to the git with a meaningful comment :)
			> The LLM Says : Done. The code has been committed to git and the calculation 5 * 6 = 30 was executed successfully.
			
#### 1.3. CODE REVIEW
	source ~sdk/rust-dev-env/release
	source ~/workspace/agent-infra/release
	cd ~/agentspace/agent-managed-rust-project
	kilo
		> your role is "code reviewer". review the code in the simple_calculator directory and evaluate the codes by using the coding principles in ~/sdk/rust-dev-env/reference-projects/PRINCIPLES.md and ~/sdk/rust-dev-env/reference-projects/COMMON_MISTAKES.md. Note the issues into the issues/REVIEW-001.md file.
			> generates comments in :
				~/agentspace/agent-managed-rust-project/.kilo/command/simple_calculator_review.md (100 lines)
				~/agentspace/agent-managed-rust-project/simple_calculator/issues/REVIEW-001.md (262 lines)

#### 1.4. CODE IMPROVEMENT
	source ~sdk/rust-dev-env/release
	source ~/workspace/agent-infra/release
	cd ~/agentspace/agent-managed-rust-project
	kilo
		> improve the code in simple_calculator project using the code review notes in ~/agentspace/agent-managed-rust-project/simple_calculator/issues/REVIEW-001.md, generate unit tests for the code, run the tests and generate a test report in simple_calculator/reports directory.
			> TRIED 3 TIMES BUT COULD NOT GENERATE THE TEST CODE DUE TO CONTEXT LENGTH LIMITATION WHICH IS 32K


#### 1.5. CODE IMPROVEMENT USING TOKEN REDUCTION TOOLS
Now we configure token reduction tools, you may check the descriptions of each tool that is used below from the [ Token Reduction ADR ](docs/ards/adr-005-context-token-reduction-tools.md)
As we do the configuretion, from now on when you run the installation scripts, it will be automatically configured, for example headroom service is automatically configured and kilo.jsonc is configured fot headroom. 
	source ~sdk/rust-dev-env/release
	source ~/workspace/agent-infra/release
	cd ~/agentspace/agent-managed-rust-project
	rtk init --agent kilocode
	#graphify kilo install
	graphify .
	caveman run -- kilo
		> improve the code in simple_calculator project using the code review notes in ~/agentspace/agent-managed-rust-project/simple_calculator/issues/REVIEW-001.md, generate unit tests for the code, run the tests and generate a test report in simple_calculator/reports directory.
			> TRIED 3 TIMES BUT COULD NOT GENERATE THE TEST CODE DUE TO CONTEXT LENGTH LIMITATION WHICH IS 32K

			
#### 1.6. CODE IMPROVEMENT USING TASK DIVISION
	source ~sdk/rust-dev-env/release
	source ~/workspace/agent-infra/release
	cd ~/agentspace/agent-managed-rust-project
	rtk init --agent kilocode
	#graphify kilo install
	graphify .
	caveman run -- kilo
		> improve the code in simple_calculator project using the code review notes in ~/agentspace/agent-managed-rust-project/simple_calculator/issues/REVIEW-001.md, 
			> TRIED 3 TIMES BUT COULD NOT GENERATE THE TEST CODE DUE TO CONTEXT LENGTH LIMITATION WHICH IS 32K
		> generate unit tests for the code, run the tests and generate a test report in simple_calculator/reports directory.
			> TRIED 3 TIMES BUT COULD NOT GENERATE THE TEST CODE DUE TO CONTEXT LENGTH LIMITATION WHICH IS 32K


			
#### 1.7. CODE IMPROVEMENT USING TASK SUB-ENUMERATION
	source ~sdk/rust-dev-env/release
	source ~/workspace/agent-infra/release
	cd ~/agentspace/agent-managed-rust-project
	rtk init --agent kilocode
	#graphify kilo install
	graphify .
	caveman run -- kilo
		> improve the code in simple_calculator project using the code review notes in ~/agentspace/agent-managed-rust-project/simple_calculator/issues/REVIEW-001.md, do it one by one. Apply each improvement one by one.
			> TRIED 3 TIMES BUT COULD NOT GENERATE THE TEST CODE DUE TO CONTEXT LENGTH LIMITATION WHICH IS 32K
		> generate unit tests for the code, run the tests and generate a test report in simple_calculator/reports directory.
			> TRIED 3 TIMES BUT COULD NOT GENERATE THE TEST CODE DUE TO CONTEXT LENGTH LIMITATION WHICH IS 32K


#### 1.8. CODE IMPROVEMENT USING MEMORY
	source ~sdk/rust-dev-env/release
	source ~/workspace/agent-infra/release
	cd ~/agentspace/agent-managed-rust-project
	rtk init --agent kilocode
	#graphify kilo install
	graphify .
	caveman run -- kilo
		> /memory enable
		> improve the code in simple_calculator project using the code review notes in ~/agentspace/agent-managed-rust-project/simple_calculator/issues/REVIEW-001.md, do it one by one. Apply each improvement one by one.
			> TRIED 3 TIMES BUT COULD NOT GENERATE THE TEST CODE DUE TO CONTEXT LENGTH LIMITATION WHICH IS 32K
		> generate unit tests for the code, run the tests and generate a test report in simple_calculator/reports directory.
			> TRIED 3 TIMES BUT COULD NOT GENERATE THE TEST CODE DUE TO CONTEXT LENGTH LIMITATION WHICH IS 32K


			
#### 1.8. CODE IMPROVEMENT USING MEMORY
	source ~sdk/rust-dev-env/release
	source ~/workspace/agent-infra/release
	cd ~/agentspace/agent-managed-rust-project
	rtk init --agent kilocode
	#graphify kilo install
	graphify .
	caveman run -- kilo
		> /memory enable
		> improve the code in simple_calculator project using the code review notes in ~/agentspace/agent-managed-rust-project/simple_calculator/issues/REVIEW-001.md, do it one by one. Apply each improvement one by one.
			> TRIED 3 TIMES BUT COULD NOT GENERATE THE TEST CODE DUE TO CONTEXT LENGTH LIMITATION WHICH IS 32K
		> generate unit tests for the code, run the tests and generate a test report in simple_calculator/reports directory.
			> TRIED 3 TIMES BUT COULD NOT GENERATE THE TEST CODE DUE TO CONTEXT LENGTH LIMITATION WHICH IS 32K


			
			
			
			
			
1. Don’t spam prompts to fix errors (Prompt Thrashing).
2. Don’t assume model is understanding ( Write Clear Prompts)
3. Don’t use too many MCP Servers (Risk of selecting wrong MCP
would increase)
4. Regularly reevaluate (possibly outdated) assumptions about the
"best" tools
5. Don’t persist with dead-end conversations

Chain of Tought (COT)
Input Data (Previous mails, examples) IN PARANTHESIS
Explicit Negative
Venn Diagram of what is possible
Intersection, Union, Exclusion



#### 1.2. Start Kilo-Code coding agent and generate code.


How I Structure Claude Code Projects So Agents Don’t Get Lost in Large Codebases (https://blog.s10n.dev/how-i-structure-claude-code-projects-so-agents-dont-get-lost-in-large-codebases-9ad69a2ebb92)
How To Use Claude Like a Senior Engineer, Not a Chatbot (https://medium.com/codetodeploy/how-to-use-claude-like-a-senior-engineer-not-a-chatbot-6490dcaf1614)

### [Simple C++ Development With One Agents] (/docs/03.01.usage.exammple.simple.qt.md)

### [Simple Qt Development With One Agents] (/docs/03.01.usage.exammple.simple.qt.md)

### [Simple Rust Development With One Agents] (/docs/03.01.usage.exammple.simple.rust.md)

### [Simple Java Development Using Skills](/docs/01.usage.exammple.simple.java.using.skills.md)
    How to create a skill worth using  (https://uxplanet.org/i-tested-20-popular-claude-code-skills-most-of-them-were-useless-6bfdf190a6d1)

If you’re building your own skill, follow this path:

    Start from a real, recurring pain, not a topic. For example, “Our checkout form keeps shipping without the analytics events wired up” is a pain worth a skill.
    Provide workflow, not individual actions. You need to guide AI on how to solve the problem. This guidance should be explain the process you follow when dealing with the problem.
    Encode the decision, not the principle. Skip “handle errors gracefully.” Write “in this service, wrap external calls in withRetry and surface failures through AppError, never raw exceptions."
    Cut anything the model does by default. If Claude already does it without being told, deleting it costs you nothing.
    Keep the main instructions short; push depth into referenced files. Use progressive disclosure and let Claude load the detail only when the task demands it.
    Measure. Run the task with and without the skill. If the output doesn’t change, or doesn’t change for the better, the skill isn’t earning its context.

### [Simple Java Development Using Multiple Coding Agents](/docs/01.usage.exammple.simple.java.md)
Multiagent example : bussiness analyst, architect, coder, document generator, unit test coder, scenario test coder, code reviewer( bitbucket) , static analyzer(mcp), test runner, test report generator, release manager, product admin, platform admin.
Skills and coding book rags

### [ Using Graphify ] (/docs/03.02.llmwiki.md)

### [ Using Obsidian ] (/docs/03.02.llmwiki.md)

### [ Using LLM Wiki ] (/docs/03.02.llmwiki.md)

### [ Using Caveman RTK Headroom Ponytai ] (/docs/03.02.llmwiki.md)
How I Cut Claude Code Token Usage by 90%+ With 5 Tools, Custom Hooks, and Enforcement (https://medium.com/@abdulgafoorabid/how-i-cut-claude-code-token-usage-by-90-with-4-tools-custom-hooks-and-enforcement-d3f8d2488cd6)

### [ Refactoring Java Projects] (/docs/03.01.usage.exammple.simple.java.md)

### [ Porting Java Project to Qt ] (/docs/03.01.usage.exammple.simple.java.md)

### [ Porting Java Project to Rust ] (/docs/03.01.usage.exammple.simple.java.md)
    
### [ Poritng Complete Code Base with multiple agent ]

    
    
