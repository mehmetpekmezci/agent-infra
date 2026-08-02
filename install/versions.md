for i in $(docker image ls| grep : |awk '{print $1}'); do    echo;echo; echo $i;docker inspect --format='{{index .Config.Labels "org.opencontainers.image.version"}}' $i; done


calciumion/new-api:latest
v1.0.0-rc.22


docker.n8n.io/n8nio/n8n:latest
2.30.7


ghcr.io/open-webui/open-webui:main
main


ghcr.io/pratiyush/llm-wiki:latest
1.3.82


grafana/grafana:latest



mongo:latest
24.04


neo4j:latest



node:slim



postgres:17



prom/prometheus:latest



protegeproject/webprotege:latest



qdrant/qdrant:latest
v1.18.3


quay.io/jupyter/base-notebook:latest
24.04


redis:latest



rustfs/rustfs:latest



searxng/searxng:latest
2026.7.19-6da6eee26


stain/jena-fuseki:latest
5.1.0


tigergraph/graphrag:latest



vllm/vllm-openai:latest
vllm/vllm-openai:v0.26.0
