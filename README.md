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
| Obsidian | TOOL | Obsidian is a popular note-taking and knowledge-management application that stores files as plain text Markdown documents on your local device| 
| Kilo-Code CLI | TOOL | An open source agentic command-line coding tool  | 
| Graphify | TOOL | an open-source tool and AI coding-assistant skill that turns a project's files—including code, documentation, PDFs, images, and videos—into a queryable knowledge graph | 
| Caveman | TOOL | Installed within Coding Agents. This tool reduces tokens before sanding to inference service |
| RTK | TOOL | Rust Token Killer is a command-line proxy sitting between your AI agent and the shell that intercepts verbose outputs (like git log) and returns clean, deduplicated, and condensed text |
| Ponytail | TOOL | It pushes the agent to reuse existing code, platform features, and dependencies before writing anything new. |



## Hardware and OS Requirements to Run This Environment:
	
1.  A computer with a NVIDIA GPU (with minimum 8GB RAM) that is supported by VLLM 

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

Clone this repository into your wworkspace directory, source the release file and run the ~/workspace/agent-infra/install/00.main.sh  script.
    
##  Starting Services

After installing services and tools, source the ~/workspace/agent-infra/release file then start services by running the ~/workspace/agent-infra/services/00.main.sh script.

##  Installing the Agent-Infra's General-Purpose Harness in your project

0. Switch to a user that can NOT execute sudo commands, and also that does NOT have git master/tag privileges.
1. Clone a copy of your project into a directory.
2. Checkout a branch that "kilo code agent" can commit. (or even push)
3. Source the release file : ~workspace/agent-infra/release 
4. Run the harness installation script : ( ~workspace/agent-infra/harness/install_kilo_harness.sh)  

This command create .kilo directory if it does not exists , and creates links (if not exists) to the skill/mode/workflow files found in the ~/workspace/agent-infra/harness directory.

NOTE: we could also install in ~/.config/kilo/ directory. But we don't prefer to make a global installation, we install to only in-repository <project_dir>/.kilo directory.

##  How to Write Prompt

1. Don’t spam prompts to fix errors (Prompt Thrashing).
2. Don’t assume model is understanding (Write Clear Prompts)
3. Don’t use too many MCP Servers / Skills / Modes / APIs ... (Risk of selecting wrong service/api would increase)
4. Regularly reevaluate (possibly outdated) assumptions about the "best" tools, skills, modes, mcps, apis ...
5. Don’t persist with dead-end conversations
5. Chain of Tought (COT) : Explain step by step what to do.
6. Input Data (previous mails, examples) should be given in paranthesis.
7. Output Data format should be explicitly specified ( list, table, json format, code, ...) 
8. If you want to emphasize something not to do, especially explain it so.
9. Specify who the output is intended for (e.g., beginner, researcher, executive, child).
10. Give explicit constraints: State requirements such as length, language, format, scope, exclusions, or deadlines.
11. Define what “success” means: Give measurable or observable criteria for a satisfactory answer. 
12. Ask for grounded reasoning: For factual or analytical tasks, request that conclusions be supported by the provided evidence or reliable sources.
13. Handle ambiguity explicitly: Tell the model whether it should ask questions, make reasonable assumptions, or provide alternatives when information is missing.
14. Decompose complex tasks: Break large objectives into sequential subtasks rather than asking for everything simultaneously.
15. Specify uncertainty behavior: Tell the model what to do when it does not know something: flag uncertainty, ask for clarification, or refrain from guessing.
16. Minimize hidden assumptions: If something matters to the result, put it explicitly in the prompt rather than assuming the model will infer it.
17. Treat the prompt as a specification: he strongest prompts resemble a good technical specification: objective + context + inputs + constraints + procedure/criteria + output format + quality requirements.
18. Venn Diagram of what is possible : Define information sets. Use intersection, union and exclusion while defining new rules.

## How to Write Skill


Skills are called automatically by kilo code agent. 

The directory structure is :

	.kilo/skills/your-skill-name/
	├── SKILL.md # Required - main skill file
	├── scripts/ # Optional - executable code
	│   ├── process_data.py # Example
	│   └── validate.sh # Example
	├── references/ # Optional - documentation
	│   ├── api-guide.md # Example
	│   └── examples/ # Example
	└── assets/ # Optional - templates, etc.
	    └── report-template.md # Example

.kilo directory (which also contains agents/modes and workflows/commands) is found in the main project directory (for example in the root directory of the project's git repository ( you can also use .agents instead of .kilo directory name and commit to git repo, .kilo name is ignored by default ).

1. Kilo Session starts ( you issue the command "kilo" )
   --> Kilo Code Agent loads: name + description from every skill (~100 tokens each)
2. User asks: "Can you write a README for this project?"
   --> Agent reads: readme-writer/SKILL.md full body (Level 2)
3. SKILL.md references a style guide file
   --> Agent reads: readme-writer/references/style.md (Level 3)
4. SKILL.md includes a validation script
   --> Agent executes: scripts/validate.sh 
   (runs without being read into context)


The description field in your YAML frontmatter is not for humans. It is the trigger condition the agent uses when deciding whether to activate your skill. 
	description: [What the skill does] + [When to use it, with specific trigger phrases] + [Key capabilities]
Bad Example: 
	description: Creates sophisticated multi-page documentation with advanced formatting.
Good Example: 
	description: Creates and writes professional README.md files for software projects. Use when user asks to "write a README", "create a readme", "document this project", "generate project documentation", or "help me write a README.md".

The agentskills.io spec defines the skill constraints:
1. name: lowercase letters, numbers, and hyphens only, max 64 characters, must not start or end with a hyphen, no consecutive hyphens
2. description: max 1024 characters, must describe both what the skill does and when to use it
3. The file must be named exactly SKILL.md, case-sensitive
4. Avoid XML angle brackets (< or >) in frontmatter as they can inject unintended instructions into the system prompt


Tests :

1. Triggering tests
   Goal: Ensure your skill loads at the right times.
   Test cases:
     - Triggers on obvious tasks
     - Triggers on paraphrased requests
     - Doesn't trigger on unrelated topics
2. Functional tests
   Goal: Verify the skill produces correct outputs.
   Test cases:
     - Valid outputs generated
     - API calls succeed
     - Error handling works
     - Edge cases covered
3. Performance comparison
   Goal: Prove the skill improves results vs. baseline.
   How will you know your skill is working :
      - Skill triggers on 90% of relevant queries
        – How to measure: Run 10-20 test queries that should trigger your skill. Track
          how many times it loads automatically vs. requires explicit invocation
      - Completes workflow in X tool calls
        – How to measure: Compare the same task with and without the skill enabled.
          Count tool calls and total tokens consumed.

Always write in third person. The description is injected into the system prompt, and inconsistent point-of-view can cause discovery problems.

    Good: "Processes Excel files and generates reports"
    Avoid: "I can help you process Excel files"
    Avoid: "You can use this to process Excel files"


ATTENTION : You have to write descriptions as clear as possible and non-ambiguous, beacuse Your Skill shares the context window with :

    The system prompt
    Conversation history
    Other Skills' metadata
    Your actual request


Define clear boundaries:

	Start with a short section that explains when this skill should be used. Is it intended for API usage? CLI workflows? 
	Git repositories? Specific permission levels? Being explicit about scope prevents agents from applying the wrong logic
	in the wrong context, and setting clear boundaries dramatically reduces misuse.

Provide a structural overview:

	Before describing workflows, orient the model. Identify the core objects in your product, key configuration files, or 
	primary entry points. This gives the agent a mental map of your system before it begins acting. LLMs perform better when they
	understand structure first, then action.

Document workflows — not features:

	Avoid abstract feature descriptions. Instead, describe how to complete real tasks step by step. If a workflow requires a specific
	sequence, state the order directly. If permissions, prerequisites, or environment setup are required, list them clearly. Precision
	reduces ambiguity — and less ambiguity makes AI behavior more reliable.

Include simple “if/then” decision rules:

	If there are multiple ways to accomplish something, clarify when to choose one over another. Short “if/then” guidance in plain
	language can significantly improve consistency. For example: if the task requires sequential steps, follow the ordered process;
	if it presents alternatives, surface options clearly. These lightweight rules help LLMs choose correctly instead of guessing.

Add guardrails and common pitfalls:

	Your skill file shouldn’t just describe what can be done — it should also define limits. Include a short section that outlines
	unsupported actions, configuration conflicts, environment constraints, or known failure modes. Negative constraints are powerful 
	for LLMs. They reduce subtle mistakes that would otherwise require human review. Finally, ensure your skill.md stays aligned with 
	your broader product documentation. It isn’t a replacement for full technical documentation — it’s a focused layer that helps AI
	agents use it correctly. If you already have product docs, this skill generator can help you build a skill.md draft from your 
	existing documentation, giving you a head-start in building skills for your product. It will still need reviewing and improving
	manually, but it may kickstart this process for you.


References :

	https://www.gitbook.com/blog/skill-md
	https://resources.anthropic.com/hubfs/The-Complete-Guide-to-Building-Skill-for-Claude.pdf
	https://bibek-poudel.medium.com/the-skill-md-pattern-how-to-write-ai-agent-skills-that-actually-work-72a3169dd7ee
	https://levelup.gitconnected.com/the-simple-guide-to-agent-skills-3d510521f11a
	https://www.skillsdirectory.com/docs/skill-file-structure
	https://ai.sulat.com/writing-opencode-agent-skills-a-practical-guide-with-examples-870ff24eec66
	https://github.com/mgechev/skills-best-practices
	https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices
	https://github.com/VoltAgent/awesome-agent-skills
	https://github.com/sickn33/agentic-awesome-skills


### Example Skill

Directory Structure :

	.kilo/
	└── skills/
	    └── summarizer-skill/
	        │
		├── SKILL.md              # Main entry point and instructions for the agent
		├── scripts/              # Executable code or helper scripts used by the agent
		│   └── process_text.py   # Python utility to perform the core task
		├── references/           # Documentation, guidelines, or source materials
		│   └── formatting_rules.md # Style guide or schema the agent must follow
		└── assets/               # Static files, templates, or binary resources
		    └── template.md       # Output markdown template

When the agent is invoked with this skill, it inspects SKILL.md, runs the code inside scripts/ to handle heavy lifting, references the guidelines in references/ for formatting checks, and populates the template found in assets/ to produce the final result.


SKILL.md :

	
	---
	name: text-summarizer
	description: Guides stable API and interface design. Use when designing APIs, module boundaries, or any public interface. Use when creating REST or GraphQL endpoints, defining type contracts between modules, or establishing boundaries between frontend and backend.

	---


	# Text Summarizer Skill

	## Overview
	This skill processes raw text inputs, applies structural formatting rules, and generates a clean, standardized report.

	## Directory Layout
	* `scripts/`: Contains the execution logic (`process_text.py`).
	* `references/`: Contains compliance and formatting guidelines (`formatting_rules.md`).
	* `assets/`: Contains output templates (`template.md`).

	## Execution Steps
	1. Read the input text provided by the user.
	2. Execute the processing script to extract key metrics and summaries:
 	  ```bash
	   python scripts/process_text.py --input "path/to/input.txt"
	   ```
	3. Consult references/formatting_rules.md to ensure compliance with output standards.
	4. Render the final output using the structure defined in assets/template.md.

scripts/process_text.py: 

	#!/usr/bin/env python3
	import argparse
	import sys

	def summarize_text(text: str) -> dict:
	    words = text.split()
	    return {
	        "word_count": len(words),
 	       "preview": " ".join(words[:10]) + ("..." if len(words) > 10 else "")
  	  }

	if __name__ == "__main__":
 	   parser = argparse.ArgumentParser(description="Process and summarize input text.")
  	  parser.add_argument("--input", type=str, required=True, help="Text to process")
 	   args = parser.parse_args()
    
 	   result = summarize_text(args.input)
	   print(f"Word Count: {result['word_count']}")
 	   print(f"Preview: {result['preview']}")

references/formatting_rules.md:

	# Formatting Compliance Rules
	1. **Tone:** Keep all generated summaries objective and concise.
	2. **Structure:** Every report must begin with metadata (Word Count, Timestamp).
	3. **Language:** Avoid colloquialisms and filler words.

assets/template.md:

	# Execution Report

	**Status:** SUCCESS  
	**Word Count:** {{word_count}}  

	## Executive Summary
	{{preview}}
	

## How to Write Modes (Agents/SubAgents)

Directory Structure :

	.kilo/
	└── agents/
	    └── *.md


1. Structure of an Mode (Agent) .md File
   An agent file consists of two primary sections: 
   - YAML Frontmatter (Header between --- blocks) : Defines metadata, UI appearance, and tool/file permissions.
   - Markdown Body: Acts as the system prompt or role definition that shapes the agent's behavior, tone, and methodology.
    
2. Best Practices for Frontmatter (Header between --- blocks) Configuration
   The frontmatter dictates what the agent can and cannot do. Leverage granular permissions to optimize safety and focus:
   - Restrict Tool Access: Limit high-risk capabilities like shell commands (bash) or unrestricted file editing for read-only or specialized review agents.
   - Use Precise File Globbing: Restrict the edit permission to specific file extensions to prevent accidental modifications to core source code.
   - Set Clear Descriptions: Write concise summaries in the description field so users understand the agent's exact use case in the agent picker.

3. Best Practices for Writing Agent Instructions (Body)
   Define a Strong Persona Immediately: Start the markdown body with a direct statement defining the agent's role (e.g., "You are a technical writing expert specializing in clear documentation...").

   - Keep Instructions Focused: Unlike project-wide AGENTS.md files (which handle global codebase rules), individual agent files should focus purely on how that specific agent executes its specialized task.
   - Specify Behavioral Constraints: Explicitly state what the agent should avoid doing (e.g., "Do not modify implementation source code" or "Always ask before executing destructive shell commands").
   - Use Clean Markdown Formatting: Organize guidelines using headers, bullet points, and bold text so the LLM parses the hierarchical instructions accurately.


Frontmatter Fields :
- description : String : A short summary displayed in the agent picker and used by the orchestrator for task delegation.
- mode : String : Role classification:• primary (user-selectable in the UI)• subagent (only invoked by other agents)• all (both) 
- model :  String : Pins a specific model using provider/model format (e.g., anthropic/claude-sonnet-4-20250514). 
- permission :  Object : Per-agent permission overrides controlling tool access (e.g., allowing or denying edit, bash).
- color : String : UI identifier color for the agent picker, specified as a hex code (#10B981) or theme keyword (primary, accent, warning). 
- steps : Integer : Maximum agentic iterations allowed before forcing a text-only response. 
- temperature / top_p : Number : Sampling parameters for the agent's underlying model. 
- variant : String : Default model variant. 
- hidden : Boolean : If true, hides the agent from the UI (typically used for background subagents). 
- disable : Boolean : If true, completely disables and removes the agent. 

Note: The agent's identifier (name) is automatically derived from its filename (minus the .md extension). Nested subdirectories create namespaced names, such as agents/backend/sql.md resulting in backend/sql.


Core Guidelines

- Clarity First: Explain complex technical concepts simply, targeting both beginner and advanced developers.
- Strict Scope: You are only permitted to edit Markdown (.md or .mdx) files. Do not attempt to modify source code files.
- Structure: Always organize documentation with logical headings, tables where appropriate, and actionable code examples.
- Tone: Professional, objective, and instructional.

References :

	https://github.com/jtgsystems/Custom-Modes-Roo-Code/
	https://github.com/rahulvrane/awesome-claude-agents
	https://github.com/anderfredx/awesome-claude-code
	https://github.com/asgeirtj/system_prompts_leaks
	https://github.com/0xfurai/claude-code-subagents
	https://github.com/wshobson/agents
	https://github.com/VoltAgent/awesome-claude-code-subagents

### Example Mode/Agent

Directory Structure :

	.kilo/
	├── agents/
	│   └── summarizer.md
	│
	└── skills/
	    └── summarizer-skill/
	        └── SKILL.md



summarizer.md :

	---
	description: Summarizes documents and technical content using the summarizer-skill.
	mode: subagent
	model: anthropic/claude-sonnet-4
	permission:
	  read: allow
	  write: deny
	  edit: deny
	  bash: deny
	color: "#8B5CF6"
	temperature: 0.2
	variant: summarizer
	hidden: false
	disable: false
	---
	
	# Summarizer Agent
	
	Use the `summarizer-skill` skill for all summarization tasks.
	
	## Steps
	
	1. Determine what the user wants summarized.
	2. Identify and read the relevant source material.
	3. Invoke and follow `summarizer-skill`.
	4. Produce the requested summary format.
	5. Verify that the summary accurately represents the source.
	6. Return the result without modifying project files.
	
	## Rules
	
	- Always use `summarizer-skill` when performing summarization.
	- Do not reproduce the skill's instructions here; use the skill itself.
	- Do not modify, create, or delete files.
	- Do not execute shell commands.
	- Do not invent information or citations.
	


### Another Example of Mode/Agent Usage


                    ┌──────────────────┐
                    │   Main Agent     │
                    │   / Orchestrator │   -----------------------> Agent, only it is written in it's instructions to use other agents.
                    └────────┬─────────┘
                             │
             ┌───────────────┼───────────────┐
             ▼               ▼               ▼
      ┌────────────┐  ┌────────────┐  ┌────────────┐
      │ Researcher │  │  Engineer  │  │  Reviewer  │--------------> Agent, it is written in their instructions to use skills.
      └─────┬──────┘  └─────┬──────┘  └─────┬──────┘
            │               │               │
        ┌───┴───┐       ┌───┴───┐       ┌───┴───┐
        ▼       ▼       ▼       ▼       ▼       ▼
      Search  Papers   Code   Tests   Critic  Editor --------------> Skill
      

      
      
	       
## How to Write Workflows (Commands) 



https://github.com/danielrosehill/Claude-Slash-Commands
https://github.com/jqueryscript/Claude-Code-Slash-Commands-Cheatsheet
https://github.com/hesreallyhim/awesome-claude-code
https://github.com/wshobson/commands
https://github.com/cassler/awesome-claude-code-setup


## How to compose a Harness using Skills/Modes/Wokrflows/Memory
Assuming you are using kilo code agent, you can install predefined skills/modes/workflows into your project directory by following these instructions :

1. Go to your project directory and run the script $AGENT_INFRA_DIR/harness/install_kilo_harness.sh. This will install predefined skilss/modes/workflows from $AGENT_INFRA_DIR/harness/ directory. The directory content is prepared using the following sites :

	https://github.com/stjbrown/agent-knowledge
 	https://github.com/addyosmani/agent-skills
	https://github.com/supabase/agent-skills
 	https://github.com/VoltAgent/awesome-agent-skills
	https://github.com/NeoLabHQ/context-engineering-kit/
	https://github.com/fvadicamo/dev-agent-skills
	https://github.com/garrytan/gstack
	https://github.com/Kilo-Org/kilo-marketplace
	https://github.com/sametbrr/llm-wiki-manager
	https://github.com/mshashank0/mcp-server-for-atlassian-ai-assistant
	https://github.com/alibaba/open-code-review
	https://github.com/ehmo/platform-design-skills
	https://github.com/cloudflare/security-audit-skill
	https://github.com/anthropics/skills
	https://github.com/NVIDIA/skills/
	https://github.com/amirkiarafiei/subagent-cli-skills
	https://github.com/obra/superpowers


## Examples 

After starting the services, we are ready to use agentic tools. 

### 1. Simple Rust Development With One Agent
#### 1.1. Prepare Work Directory and Github Repository
	mkdir -p ~/agentspace
	cd ~/agentspace
	git clone git@github.com:mehmetpekmezci/agent-managed-rust-project.git
	
#### 1.2. Code Generation
We prepared rust development environment using https://github.com/havelsan/rust-dev-env in directory ~/sdk/rust-dev-env. We will use the compiler and cargo from this directory.
	source ~/sdk/rust-dev-env/release
	source ~/workspace/agent-infra/release
	cd ~/agentspace/agent-managed-rust-project
	## NOTE: WE USE CTRL-INSERT TO PASTE TEXT.
	kilo
		> 1. create a directory with name simple_calculator
		> 2. create a rust project with the same name in simple_calculator
		> 3. implement a simple calculator in main.rs with the following detail :
		  3.1. main.rs reads first value, math operator, second value as float value from terminal
		  3.2. main.rs performs the operation 
		  3.3. main.rs prints the result
		> 4. run the main and feed the values 5 + 2 if interactive.
		> 5. commit all source codes in simple_calculator to the git with a meaningful comment :)
			> The LLM Says : Done. Source code committed to git with meaningful commit message.
		> exit
			
#### 1.3. Code Review
	source ~sdk/rust-dev-env/release
	source ~/workspace/agent-infra/release
	cd ~/agentspace/agent-managed-rust-project
	kilo
		> your role is "code reviewer". review the code in the simple_calculator directory and evaluate the codes by using the coding principles in ~/sdk/rust-dev-env/reference-projects/PRINCIPLES.md and ~/sdk/rust-dev-env/reference-projects/COMMON_MISTAKES.md. Run cargo clippy --all-targets --all-features to verify warnings. Note the issues into the ~/agentspace/agent-managed-rust-project/simple_calculator/issues/REVIEW-001.md  file.
			> The LLM generates comments in ~/agentspace/agent-managed-rust-project/simple_calculator/issues/REVIEW-001.md (262 lines)

#### 1.4. Code Improvement
	source ~sdk/rust-dev-env/release
	source ~/workspace/agent-infra/release
	cd ~/agentspace/agent-managed-rust-project
	kilo
		> Make a step by step plan for to improve the code in simple_calculator project using the code review notes in ~/agentspace/agent-managed-rust-project/simple_calculator/issues/REVIEW-001.md and write the into ~/agentspace/agent-managed-rust-project/simple_calculator/plans/PLAN-01.md.  Steps of the plan should be as small as possible so that we can fit into 32k context :) 
			> The LLM Says : Plan generated.
		> Execute each step one by one. Write the executed steps of the plan into ~/agentspace/agent-managed-rust-project/simple_calculator/plans/PLAN-REPORT-01.md
			> The LLM Says : Compaction exhausted: context still exceeds model limits after 3 attempts



#### 1.5. Code Improvement Using Token Reduction Tools
Now we configure token reduction tools, you may check the descriptions of each tool that is used below from the [ Token Reduction ADR ](docs/ards/adr-005-context-token-reduction-tools.md)
As we do the configuretion, from now on when you run the installation scripts, it will be automatically configured, for example headroom service is automatically configured and kilo.jsonc is configured fot headroom. 
	source ~sdk/rust-dev-env/release
	source ~/workspace/agent-infra/release
	cd ~/agentspace/agent-managed-rust-project
	rtk init --agent kilocode
	graphify kilo install
	graphify .
	graphify cluster-only .
	echo "## Context Navigation (Graphify Memory)
             - Always check 'graphify-out/' or 'graphify-out/obsidian/' to understand the codebase structure and module relationships before exploring raw source files.
             " > ~/agentspace/agent-managed-rust-project/AGENTS.md 
	caveman run -- kilo
		> Execute each step one by one. Write the executed steps of the plan into ~/agentspace/agent-managed-rust-project/simple_calculator/plans/PLAN-REPORT-01.md . run the tests one last time before returning me.
			> The LM Syas : All 8 tests passed successfully. The tests cover:
                                        - Arithmetic operations: addition, subtraction, multiplication, division
                                        - Error cases: invalid first value, invalid second value, invalid operator, division by zero
	Use "rtk gain" to see how much you saved by using rtk.
	Use "caveman stats" to see how much you saved by using caveman. 
        To be sure about graphify output is used by kilo code , we ask to kilo code : "What are the primary God nodes and cross-module connections in this codebase based on the graphify report"
        
### 2 Building Harness

32K context içinde rust projeleri geliştireceğiz veya vllm +  LLM AutoEncoder Latent Vector ile büyük LLM'leri küçük GPU'ya sığdırma.




Agent = Model + Harness. The harness does six things the model cannot do on its own. 
1. It shapes what the model sees on each call (context assembly). 
2. It decides what the model is allowed to do (tool contracts and validators). 
3. It remembers what happened across calls (memory and durable state). 
4. It watches what the model produced (observability, verification, drift detection, evaluation gates). 
5. It recovers when something goes wrong (retry, rollback, checkpointing, replay).
6. It coordinates multiple agents (orchestration, subagents, human-in-the-loop, agent-to-agent protocols). (Rick Hightower)



Framework vs Harness:
A framework gives you abstractions, libraries, and components for building agent systems. The harness is the operational system surrounding the model. It determines which actions are available, what actually executes, how results are checked, and what happens after failure. In doing so, the harness governs system execution across context, tools, state, orchestration, verification, observability, and control. In contrast, a framework can be used to implement parts of a harness. You can combine multiple frameworks within a harness or choose not to use a dedicated agent framework at all. Consequently, the distinction between agent frameworks and agent harnesses lies in implementation tooling versus system responsibility and control.


Harness design has matured from ad-hoc scripting into a systems-engineering discipline with its own lifecycle, security model, and token economics. That system is your harness: the engineered layer around your AI agents that constructs context, governs tool interaction, manages state, orchestrates execution, interprets feedback, verifies outcomes, and enforces constraints. The model supplies general-purpose intelligence during inference, but the harness turns that inference into situated, persistent, controlled intelligence and interpretable behavior. Increasingly, the harness itself becomes a learnable system layer that can be adjusted and optimized while the underlying model remains fixed.



 Figure 1-1 shows the main harness layers that you author, own, and improve, and how they work together as a closed operational loop.
 
 Figure 1-1 separates the harness into six layers that play different roles in your operational loop. The following briefly explains what each layer is about and why it is important for your agent system.

 Figure 1-2 places prompt engineering and context engineering side by side with this broader stage of harness engineering. 
 You’ll notice that the model is fixed in all three columns. What changes is how much of the system around the model you are willing to treat as something you deliberately engineer.
 



If you look closely at the figure, you’ll notice that the diagram closes. The harness is not a stack of disconnected components, but a closed operational and improvement loop. Your runtime behavior becomes observable, observability supports verification, verification provides the signal for adaptation, and adaptation changes how the system behaves the next time it runs.





    
    
    
    
    
The Harness Is More Than a Wrapper

If you look at an AI agent system, it’s easy to think that the code around the model is just a temporary wrapper. But as the incident example shows, the model is only the reasoning engine. The harness is where your business logic, policies, and operational reality live. A model doesn’t know your company’s rollback permissions, nor should you rely on it to enforce them reliably. The harness is the system of record for how work actually gets done in your application.




1    The tool set defines which read-only actions the harness can expose during execution.
2    The recorder gives later components access to observations and traces produced as execution progresses.
3    The tool gateway connects governance, tool access, execution, and observability rather than letting the model invoke the environment directly.
4    Verification receives the recorder because it needs evidence produced elsewhere in the harness to evaluate the result.
5    Orchestration brings the components together and uses their outputs to control what happens next.    
    
However, making your agents stateful doesn’t mean that state exists in only one place or for one lifetime inside your harness. Some state exists only for the current model decision, some tracks the progress of your workflow, some reflects what is happening in the external environment, and some must survive beyond the active execution altogether. The following gives you an overview of how you can separate the state your harness manages into four categories.

Model context

    The information currently visible to the model.
Workflow state

    The current task position, completed steps, pending actions, retry counts, and intermediate results.
Operational state

    The state of the external environment, including files, services, deployments, approvals, and tool outputs.
Durable state

    Information persisted outside the active run so that the system can resume, inspect, reuse, or audit it later.

The four state categories describe different lifetimes, but they also clarify an important boundary between the model and the harness. The model can only decide over the state that enters its current context. It doesn’t inherently know where the task is in a longer workflow, which effects have already happened, which approvals are pending, or which artifacts another agent produced unless the harness makes that information available.

    
    
    
    
    
    
    
    
    
    
    
    
    


https://github.com/wquguru/harness-books


Search Harness Engineering
search Jarosław Wąsowski

https://medium.com/@asimsultan2/agent-harness-engineering-the-new-layer-of-ai-that-everyone-will-be-talking-about-a500dd80c2dd

https://medium.com/@johnklaumann/harness-engineering-agent-llm-router-and-ai-coding-ffacb012ecbe



How I Structure Claude Code Projects So Agents Don’t Get Lost in Large Codebases (https://blog.s10n.dev/how-i-structure-claude-code-projects-so-agents-dont-get-lost-in-large-codebases-9ad69a2ebb92)
How To Use Claude Like a Senior Engineer, Not a Chatbot (https://medium.com/codetodeploy/how-to-use-claude-like-a-senior-engineer-not-a-chatbot-6490dcaf1614)


How to create a skill worth using  (https://uxplanet.org/i-tested-20-popular-claude-code-skills-most-of-them-were-useless-6bfdf190a6d1)

If you’re building your own skill, follow this path:

    Start from a real, recurring pain, not a topic. For example, “Our checkout form keeps shipping without the analytics events wired up” is a pain worth a skill.
    Provide workflow, not individual actions. You need to guide AI on how to solve the problem. This guidance should be explain the process you follow when dealing with the problem.
    Encode the decision, not the principle. Skip “handle errors gracefully.” Write “in this service, wrap external calls in withRetry and surface failures through AppError, never raw exceptions."
    Cut anything the model does by default. If Claude already does it without being told, deleting it costs you nothing.
    Keep the main instructions short; push depth into referenced files. Use progressive disclosure and let Claude load the detail only when the task demands it.
    Measure. Run the task with and without the skill. If the output doesn’t change, or doesn’t change for the better, the skill isn’t earning its context.


Multiagent example : bussiness analyst, architect, coder, document generator, unit test coder, scenario test coder, code reviewer( bitbucket) , static analyzer(mcp), test runner, test report generator, release manager, product admin, platform admin.
Skills and coding book rags

https://github.com/garrytan/gstack
https://github.com/Kilo-Org/kilo-marketplace
https://github.com/addyosmani/agent-skills
https://github.com/obra/superpowers


Coding Skills/Harnesses

    Karpathy (https://github.com/multica-ai/andrej-karpathy-skills)
    
    Rust (https://github.com/leonardomso/rust-skills)
    
    Qt (https://github.com/theqtcompanyrnd/agent-skills, https://www.qt.io/blog/introducing-qt-agentic-development-skills)
    
    Voltagent Agent Skills (https://github.com/VoltAgent/awesome-agent-skills)
    
    Dev Skills (https://github.com/jamestorrevillas/dev-skills)
    
    Skillizer (https://github.com/skullzarmy/skillerizer)
    
    Anthropics (https://github.com/anthropics/skills/)
    
    Design Skills (https://github.com/bergside/awesome-design-skills)
    
    Hexagonal Skills (https://github.com/affaan-m/ECC/blob/main/skills/hexagonal-architecture/SKILL.md)
    
    Java Coding Standards Skills (https://github.com/vibeeval/vibecosystem/blob/main/skills/java-coding-standards/SKILL.md)
    https://lazyskills.sh/skills/java
    https://github.com/pepperize/java-skills
    https://github.com/agentscope-ai/agentscope-java
    https://github.com/brunoborges/jdb-agentic-debugger
    https://github.com/soujava/agent-skills
    https://github.com/jdubois/dr-jskill
    
    Awesome Claude Skills (https://awesomeclaude.ai/awesome-claude-skills)
    
    Harnesses (https://medium.com/intuitively-and-exhaustively-explained/towards-self-repairing-and-repeatable-ai-systems-9371046804e5)

    Harness Repo-1 (https://github.com/Ancienttwo/repo-harness)

    Harness for Devops (https://github.com/harness/harness)

    Harness Links Repo (https://github.com/walkinglabs/awesome-harness-engineering)

    Harness Long-Horizon (https://github.com/AMAP-ML/LongHorizon-Harness)

    Harness Team-Arch Factory (https://github.com/revfactory/harness)

    Harness Skills (https://github.com/harness/harness-skills)

    Harness Developer Hub (https://developer.harness.io/docs/internal-developer-portal/flows/workflows-tutorials/github-repo-onb/)

    Harness Engineering (https://skywork.ai/skypage/en/ultimate-guide-harness-engineering-tools/2054107263857094657)

    NASA's 10 rules
    
    Elon Musk's Advice

MCP Servers
 
    Atlassian (https://github.com/mshashank0/mcp-server-for-atlassian-ai-assistant)
    
    All MCP Servers (https://mcpservers.org/)

