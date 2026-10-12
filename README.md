# agent-infra

Agent-infra repository contains scripts, descriptions and example use cases of a local/offline/air-gapped agentic development environment.

In this repository we describe: 
 
1. Architecture Design Records about tool/service choices among other alternatives.
2. How to trigger installation and services scripts.
3. Simple usage example of each tool/service individually.
4. Usage of these tools/services in a full cycle development scenario.


**CAUTION:**
1. "Kilo Code" wtiher CLI or VSCode extension, should be run in a non-privileged account of operating system. In ubuntu 24.04, perform the installations which are described below,  and start the services using an account with a SUDO privileged account. After starting the services
, you should switch to an account with no SUDO privilege while running "Kilo Code" executable or vs code extension.
 
2. If "Kilo Code" is using a system like issue tracker / DB / any type of server, the user account provided to "kilo code" agents should not have any admin privilege.

**ATTENTION:** 
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


## Simple Usage Example 

After starting the services, we are ready to use kilo agentic coding tool. 

#### Prepare Work Directory

	mkdir -p ~/agentspace/agent-managed-rust-project
	cd ~/agentspace/agent-managed-rust-project


	
#### Code Generation
We prepared rust development environment using https://github.com/havelsan/rust-dev-env in directory ~/sdk/rust-dev-env and we will use the compiler and cargo from that directory.

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
		
	
#### Code Review

	source ~sdk/rust-dev-env/release
	source ~/workspace/agent-infra/release
	cd ~/agentspace/agent-managed-rust-project
	kilo
		> your role is "code reviewer". review the code in the simple_calculator directory and evaluate the codes by using the coding principles in ~/sdk/rust-dev-env/reference-projects/PRINCIPLES.md and ~/sdk/rust-dev-env/reference-projects/COMMON_MISTAKES.md. Run cargo clippy --all-targets --all-features to verify warnings. Note the issues into the ~/agentspace/agent-managed-rust-project/simple_calculator/issues/REVIEW-001.md  file.
			> The LLM generates comments in ~/agentspace/agent-managed-rust-project/simple_calculator/issues/REVIEW-001.md (262 lines)


#### Code Improvement

	source ~sdk/rust-dev-env/release
	source ~/workspace/agent-infra/release
	cd ~/agentspace/agent-managed-rust-project
	kilo
		> Make a step by step plan for to improve the code in simple_calculator project using the code review notes in ~/agentspace/agent-managed-rust-project/simple_calculator/issues/REVIEW-001.md and write the into ~/agentspace/agent-managed-rust-project/simple_calculator/plans/PLAN-01.md.  Steps of the plan should be as small as possible so that we can fit into 32k context :) 
			> The LLM Says : Plan generated.
		> Execute each step one by one. Write the executed steps of the plan into ~/agentspace/agent-managed-rust-project/simple_calculator/plans/PLAN-REPORT-01.md
			> The LLM Says : Compaction exhausted: context still exceeds model limits after 3 attempts


As you see from the LLM response, LLM could not make the improvement, so we tried to reduce the number of tokens, wihch is shown in next section.

#### Code Improvement Using Token Reduction Tools

Now we configure token reduction tools, you may check the descriptions of each tool that is used below from the [ Token Reduction ADR ](docs/ards/adr-005-context-token-reduction-tools.md)


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
        
        

##  Installing the Agent-Infra's Code Development Harness in your project

0. Switch to a user that can NOT execute sudo commands, and also that does NOT have git master/tag privileges.
1. Clone a copy of your project into a directory.
2. Checkout a branch that "kilo code agent" can commit. (or even push)
3. Source the release file : ~workspace/agent-infra/release 
4. Run the harness installation script : ( ~workspace/agent-infra/harness/install_kilo_harness.sh)  

This command create .kilo directory if it does not exists , and creates links (if not exists) to the skill/mode/workflow files found in the ~/workspace/agent-infra/harness directory.

NOTE: we could also install in ~/.config/kilo/ directory. But we don't prefer to make a global installation, we install to only in-repository <project_dir>/.kilo directory.

##  How to Write Prompt

1. Don’t spam prompts to fix errors (Prompt Trashing).
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


### Why does it matter?

Where it actually helps:

- Consistency over time/across sessions. Without a SKILL.md, Kilo might reach for a different error-handling style, crate, or pattern each session (e.g. anyhow vs thiserror, Arc<Mutex<>> vs message-passing). A SKILL.md locks in one approach, so the codebase doesn't accumulate stylistic drift — which is a real, measurable quality factor (readability, maintainability).
- Avoiding repeated known mistakes. If your project has caught Kilo (or anyone) making a specific class of error before — e.g., a lifetime-related footgun, wrong async runtime assumption, a bad pattern for FFI/unsafe blocks — writing that down means it isn't repeated. This is a real quality lift because it encodes negative feedback that pure code-reading can't surface.
- Correct project-specific context. Things like "this compiles with no_std," "we target this MCU/toolchain version," "this crate is banned for licensing reasons" — get these wrong and code technically compiles but is wrong for your constraints. A SKILL.md prevents that class of error entirely.
- Enforcing verification steps. If the SKILL.md says "always run cargo clippy --all-targets -- -D warnings and cargo test before considering a task done," that's a real quality gate that wouldn't otherwise happen automatically.

Where it doesn't help:

- It won't make Kilo better at algorithm design, borrow-checker reasoning, or catching subtle logic bugs — that's a function of the model's underlying capability, not the presence of a document.
- A vague or generic SKILL.md ("write clean code," "follow best practices") adds essentially nothing — the value is proportional to how specific and enforceable the instructions are.

So: think of it less as "smarter Rust" and more as "fewer preventable mistakes and less inconsistency" — which is a genuine quality improvement, but a different kind than raw coding skill.


If you’re building your own skill, follow this path:

- Start from a real, recurring pain, not a topic. For example, “Our checkout form keeps shipping without the analytics events wired up” is a pain worth a skill.
- Provide workflow, not individual actions. You need to guide AI on how to solve the problem. This guidance should be explain the process you follow when dealing with the problem.
- Encode the decision, not the principle. Skip “handle errors gracefully.” Write “in this service, wrap external calls in withRetry and surface failures through AppError, never raw exceptions."
- Cut anything the model does by default. If Claude already does it without being told, deleting it costs you nothing.
- Keep the main instructions short; push depth into referenced files. Use progressive disclosure and let Claude load the detail only when the task demands it.
- Measure. Run the task with and without the skill. If the output doesn’t change, or doesn’t change for the better, the skill isn’t earning its context.

(https://uxplanet.org/i-tested-20-popular-claude-code-skills-most-of-them-were-useless-6bfdf190a6d1)

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

### Why does it matter?
Net effect for a Rust project: SKILL.md gives Kilo the knowledge (your conventions, gotchas, build commands); subagents give you division of labor with constrained permissions (a read-only explorer can't accidentally edit code; a specialized reviewer only sees what it needs); Plan Mode gives you a checkpoint before changes are made. Together they reduce wasted tokens, prevent unwanted edits, and make behavior more predictable across a large or safety-sensitive codebase.

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
      


## How to Write MCPs 
 
There are already good guides on the web about this topic :

	https://modelcontextprotocol.io/docs/2026-07-28/getting-started/intro
	https://modelcontextprotocol.io/docs/2026-07-28/develop/build-server
	https://modelcontextprotocol.info/docs/tutorials/writing-effective-tools/
	


## Building Harness using Skills + Modes(Agents) + Memory + MCPs

We build a harness for our development environment.  We will use the following main parts in our development environment, so the harness will be built around them :

1. rust
2. gitea
3. kilo code

### Gitea Check List

1. If you did not already install rust-dev-env : checkout and install https://github.com/havelsan/rust-dev-env to ~/sdk directory
    -  source release file
    -  go to rust-dev-env/rust directory and run install.sh
    -  go to rust-dev-env/devops directory and run install.sh , also follow the instructions in README.md file in that directory to create example users , projects and organizations. Also creating PERSONAL ACCESS TOKEN is written in that README.md file.
    
2. Start the gitea if not already started :
    - cd ~/sdk/rust-dev-env/devops/bin; ./run_gitea.sh
    - This starts gitea at URL : "http://localhost:13000"

3. Gitea-mcp binary is also installed while installing gitea, you may also test it 
     - source ~/sdk/rust-dev-env/release
     - gitea-mcp -t stdio --host "http://localhost:13000" --token "7dcf5fa2452b48cbd4c91045996fc6e4e4115428"
           - We assume that the token in this command was generated in the first step by reading the devops/README.md 
           - After writing this command , we send following json messages and expect any response. If we obtain any response, gitea and mcp are working.
                 - {"jsonrpc":"2.0","id":1,"result":{"capabilities":{"tools":{}},"protocolVersion":"2024-11-05","serverInfo":{"name":"Gitea MCP Server","version":"1.8.0"}}}
                 - {"jsonrpc": "2.0", "method": "tools/list", "id": 1}
 
### Kilo Code Check List

1. Check the .config/kilo/kilo.jsonc file, this should be the same as $AGENT_INFRA_DIR/install/23.kilo.jsonc  file and should contain mcp part. 

2. Gitea-mcp test :
   - On the Gitea web interface as admin user :
        - Create a user in gitea (e.g. cargo-test-access) , 
        - create an organization that cargo-test-access acan write (e.g. cargo-test), 
        - create a repository in that organization (e.g. test-repo-01).
   - On the Gitea web interface as cargo-test-access user 
        - generate access token for that user ( settings > applications ) (e.g. 3e55118794c5ed85a2ce0bad8324ed501c36e604)
   - export GITEA_USER_PAT="3e55118794c5ed85a2ce0bad8324ed501c36e604" in terminal.
   - Run the kilo command in terminal.
   - Give the command : 'create an issue in the test-repo-01 with tiltle "NEW_TEST_ISSUE" and body "ISSUE BODY ABCD" and assign to to the cargo-test-access user '
   - After this command you shoud see "NEW_TEST_ISSUE" issue created under test-repo-01.

 
  
### Roles

| Role No | Role Name                             | Description               |
| ------: | ------------------------------------- | ---------------------- |
|   **1** | Human                                 |  Starts the project by assigning an issue to the coordinator. Every critical decision should be asked to this role through the gitea issues.|
|   **2** | Coordinator                           |  Central coordination agent. Owns project-level workflow; communicates with the Human and all agents through Gitea Issues; assigns, tracks, and escalates work. Every worker can assign issue only to Coordinator.|
|   **3** | Worker                                |  Coordinator starts a worker then loads an agent definition from the harness library. Every agent finishes it's work by assigning an output issue to the coordinator or by setting an issue to "work done" status. |
 

### Agent Skills Catalog (Rust, Gitea-driven)

Each skill is a `skill.md` that agents load, with a matching helper script. Conventions: scripts live in `.agents/scripts/`, read the Gitea token and project settings from environment variables, print JSON to stdout, return a non-zero exit code on failure, and support `--dry-run`. Agent numbers refer to the 82-role table; `ALL` means every role.

| Skill No | Skill Name | Used by Agents | Skill Description | Script Description |
|--:|---|---|---|---|
| 1 | `gitea-issue-management` | ALL (1–82) | Create, comment on, label, assign, link and close Gitea issues using the project label scheme (role:N, phase:x, gate:y). Gitea issues are the only communication channel between agents. | `gitea_issue.sh` wraps the Gitea REST API (create, comment, label, assign, close, list); reads the token from env and prints the issue JSON |
| 2 | `role-handoff-protocol` | ALL (1–82) | Write a structured handoff comment (inputs consumed, artifacts produced, status, open questions, next role) so the next agent can start without re-reading the thread. | `handoff.py` posts the handoff block, sets the next-role label, and fails if a declared artifact path is missing |
| 3 | `command-parsing-dispatch` | 2 | Validate a command and its parameters against the schema, merge defaults, policy file and overrides, and resolve the role chain. | `parse_command.py` validates args against a JSON schema, merges `.agents/policy.toml`, and emits the epic YAML |
| 4 | `epic-decomposition` | 2, 5, 7 | Break an epic into child issues with owners, estimates, dependencies and acceptance criteria. | `decompose_epic.py` creates child issues from templates and links them as blockers or dependents |




### Building .kilo harness set

I prompted the following text in the claude.ai web interface that it gave me kilo code commands, agents and skills that are loaded on demand.

1. can you create a .kilo/commands, and .kilo/agents and .kilo/skills and .kilo/skills/scripts all for these commands, agents, skills listed above as a zip file?
2. as i only have 32kb context size, i need to implement commands, agents, skills that will be enabled / disabled dynamically (loaded/unloaded from context) by using different levels of agentic memories
3. also can you make use of rtk, caveman , graphify , ponytail in your md files and scripts, and reprepare the zip file?
4. i need the developer and other roles to pay attention to these topic also , can you add these to the md files  of kilo dynamic pack, as topics to pay attention before starting to work   :  0. every code should be written in domain driven architecture, clean code and test driven approach. 1.  for the coordinator : read $RUST_DEV_ENV/books/rust_design_patterns.pdf and summarize it part by part  and output to summaries/rust_design_patterns.pdf.md file if this file does not exists. And for the developer and reviewer roles , they should obey the patterns summarized in it. 2.  developers and reviewers should pay attention to $SDK_DEV_ENV/reference-projects/COMMON_MISTAKES.md and reference-projects/PRINCIPLES.md 3. Pay attention to karpathy rules , download and put the files in .kilo directory the file https://github.com/multica-ai/andrej-karpathy-skills/blob/main/skills/karpathy-guidelines/SKILL.md as karpathy_skill.md .
5. I added two bullets manually in coordinator.md :
   - Analyze the assigned issue or document link assigned using a gitea issue, checks consistency, ambiguity, contradiction, Completeness, Redundancy, Validity, Relevance, Accuracy, Clarity, Correctness, Entailment, Satisfiability.          
   - In each step, every agent sends it's task to researcher to check if there already is an open source program / library. This agent makes research on the internet using google.com, scholar.google.com, or any ai site if it can.
6. Go to $AGENT_INFRA_DIR/harness/kilo_commands_agents_skills/dot.kilo/library/agents, create a gitea user for all agents in 

### Installing and Using .kilo harness set

Go to your project directory and run the script $AGENT_INFRA_DIR/harness/install_kilo_harness.sh. This will install predefined skilss/modes/workflows from $AGENT_INFRA_DIR/harness/ directory. The directory content is prepared using the following sites :




