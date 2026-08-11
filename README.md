# agent-infra
Infra modules and installation scripts for ai agents and ai-powered software development environment.

## REQUIREMENTS:
1.  A computer with a NVIDIA GPU that is supported by VLLM 

    For the list of GPUs supported by VLLM : https://docs.vllm.ai/en/stable/getting_started/installation/gpu/#requirements

    For the GPU size calculation : https://www.digitalocean.com/community/conceptual-articles/vllm-gpu-sizing-configuration-guide

2.  Ubuntu 24.04

##  INSTALLATION 

List of installed components and installation descriptions : [INSTALLATION] (docs/01.install.md)
    
##  CONFIGURATION

Configuration of installed components : [CONFIGURATION] (docs/02.configure.md)

##  USAGE

Usage Examples of this AI-Powered Software Development Environment.

### [Simple Java Development With Coding Agents] (/docs/03.01.usage.exammple.simple.java.md)
Multiagent example : bussiness analyst, architect, coder, document generator, unit test coder, scenario test coder, code reviewer( bitbucket) , static analyzer(mcp), test runner, test report generator, release manager, product admin, platform admin.
Skills and coding book rags

### [Simple Qt Development With Coding Agents] (/docs/03.01.usage.exammple.simple.qt.md)

### [Simple Rust Development With Coding Agents] (/docs/03.01.usage.exammple.simple.rust.md)

### [ Using LLM Wiki ] (/docs/03.02.llmwiki.md)

### [Refactoring Java Projects] (/docs/03.01.usage.exammple.simple.java.md)

### [Porting Java Project to Qt ] (/docs/03.01.usage.exammple.simple.java.md)

### [Porting Java Project to Rust ] (/docs/03.01.usage.exammple.simple.java.md)
    
### [ Poritng Complete Code Base with multiple agent ]

## Important Tips 

### How I Structure Claude Code Projects So Agents Don’t Get Lost in Large Codebases (https://blog.s10n.dev/how-i-structure-claude-code-projects-so-agents-dont-get-lost-in-large-codebases-9ad69a2ebb92)

### How To Use Claude Like a Senior Engineer, Not a Chatbot (https://medium.com/codetodeploy/how-to-use-claude-like-a-senior-engineer-not-a-chatbot-6490dcaf1614)

### How I Cut Claude Code Token Usage by 90%+ With 5 Tools, Custom Hooks, and Enforcement (https://medium.com/@abdulgafoorabid/how-i-cut-claude-code-token-usage-by-90-with-4-tools-custom-hooks-and-enforcement-d3f8d2488cd6)

### How to create a skill worth using  (https://uxplanet.org/i-tested-20-popular-claude-code-skills-most-of-them-were-useless-6bfdf190a6d1)

If you’re building your own skill, follow this path:

    Start from a real, recurring pain, not a topic. For example, “Our checkout form keeps shipping without the analytics events wired up” is a pain worth a skill.
    Provide workflow, not individual actions. You need to guide AI on how to solve the problem. This guidance should be explain the process you follow when dealing with the problem.
    Encode the decision, not the principle. Skip “handle errors gracefully.” Write “in this service, wrap external calls in withRetry and surface failures through AppError, never raw exceptions."
    Cut anything the model does by default. If Claude already does it without being told, deleting it costs you nothing.
    Keep the main instructions short; push depth into referenced files. Use progressive disclosure and let Claude load the detail only when the task demands it.
    Measure. Run the task with and without the skill. If the output doesn’t change, or doesn’t change for the better, the skill isn’t earning its context.
    
    
