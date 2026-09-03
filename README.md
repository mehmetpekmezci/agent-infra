# agent-infra
ATTENTION: After cloning this repository, source the release file found in the repository before running any script .

Agent-infra repository contains scripts, descriptions and example use cases of a local/offline/air-gapped agentic development environment.

In this repository we describe: 
1. Architecture Design Records about tool/service choices among other alternatives.
2. Simple usage example of each tool/service individually.
3. Usage of these tools/services in a full cycle development scenario.


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
| Headroom | TOOL | It compresses tool outputs, logs, files, RAG chunks, and conversation history before they reach the model. It is also reversible: the original is cached, so the agent can pull it back if it actually needs it. |
| Ponytail | TOOL | It pushes the agent to reuse existing code, platform features, and dependencies before writing anything new. |
| Opendataloader | TOOL | OpenDataLoader PDF is a high-performance, open-source document parsing engine developed by Hancom that converts complex PDF documents into structured data like Markdown, JSON, and HTML. |



## Hardware and OS Requirements to Run This Environment:
	
1.  A computer with a NVIDIA GPU that is supported by VLLM 

    For the list of GPUs supported by VLLM : https://docs.vllm.ai/en/stable/getting_started/installation/gpu/#requirements

    For the GPU size calculation : https://www.digitalocean.com/community/conceptual-articles/vllm-gpu-sizing-configuration-guide

2.  Ubuntu 24.04

3.  Sudo authorization in the operating system.

##  Architecture Design Records

Architecture design records about :

1. Why we choose VLLM : [VLLM_ADR](docs/adrs/adr-001-ineference-engine-vllm.md)
2. Why we choose kilo-code among other coding assistants : [CODING_ASSISTANTS](docs/adrs/adr-002-ai-assistants.md)
3. How we use deep seek harness and kilo-code: [DEEP_SEEK_HARNESS_USAGE](docs/adrs/adr-003-deepseek-harness.md)
4. How we use Plugins/APIs and MCPs : [MCP_and_HARNESS](docs/adrs/aadr-004-mcp-vs-plugins.md)
5. How we do context token reduction :  [MCP_and_HARNESS](docs/adrs/adr-005-context-token-reduction-tools.md)


##  Installation of Services and Tools 

Installation scripts can be found in "install" directory. After cloning this repository, source the release file, go to intall directory and run "00.main.sh" to start installing services and tools. 
    
##  Starting Services

After installing services and tools, we start our services using the "services/00.main.sh" script which triggers other start scripts in this directory.

##  Usage

After starting the services, we are ready to use agentic tools. 

### [Simple Java Development With One Agent](/docs/01.usage.exammple.simple.java.one.agent.md)
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

    
    
