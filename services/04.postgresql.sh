
mkdir -p $AGENT_INFRA_DATA_DIR/pgdata

docker run --name my-postgres -e POSTGRES_PASSWORD=mysecretpassword -p 5432:5432 -v $AGENT_INFRA_DATA_DIR/pgdata:/var/lib/postgresql/data -d postgres

