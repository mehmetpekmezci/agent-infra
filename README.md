# agent-infra
Infra modules and installation scripts for ai agents

## REQUIREMENTS:
1.  A computer with a NVIDIA GPU that is supported by VLLM 
    https://docs.vllm.ai/en/stable/getting_started/installation/gpu/#requirements
    https://www.digitalocean.com/community/conceptual-articles/vllm-gpu-sizing-configuration-guide
2.  Ubuntu 24.04

## HOW TO INSTALL
1. Clone this repository
2. source the release file 
3. go to install directory and run 00.main.sh , which will execute all the other installers sequentially.


## WHAT WILL IT INSTALL 

Core Infrastructure

    Docker Engine

    Docker Compose

    NVIDIA Container Toolkit ( CUDA DRIVERS ARE FOUND IN THE DOCKER IMAGES, NOT INSTALLED ON THE HOST MACHINE)

AI

    vLLM

    Open WebUI

Automation

    n8n

Knowledge Engineering

    Protégé Desktop

    WebProtégé

    Apache Jena Fuseki

    Neo4j

    LLMWiki

RAG

    Qdrant

    GraphRAG

    Apache Tika

    SearXNG

Storage

    RustFS (S3-compatible Object Storage)

Databases

    PostgreSQL

    Redis

    MongoDB

Monitoring

    Prometheus

    Grafana

Development

    Visual Studio Code

    Kilo Code

    Python

    uv

    Git

    Git LFS

    Node.js

    Docker Extension

    Jupyter
