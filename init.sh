#!/bin/bash

##########################
## Init docker environment
##########################

# Variables
NETWORK_NAME="${NETWORK_NAME:-milvue-network}"
ENV_NAME="${ENV_NAME:-test}"
DOCKER_IMAGE_TAG="${DOCKER_IMAGE_TAG:-v2.4.1}"
ADMIN_TOKEN="${ADMIN_TOKEN:-$(uuidgen)}"
DOMAIN_NAME="${DOMAIN_NAME:-${ENV_NAME}.predict.milvue.com}"
ACME_EMAIL="${ACME_EMAIL:-support@milvue.com}"
AUTHENTICATION_KEY="${AUTHENTICATION_KEY}"
DEVICE="${DEVICE:-gpu}"

if [ -z "$AUTHENTICATION_KEY" ]; then
    echo "AUTHENTICATION_KEY is not set. Please give a valid."
    exit 1
fi

# Create Docker network
if ! docker network inspect "$NETWORK_NAME" >/dev/null 2>&1; then
    echo "Creating Docker network: $NETWORK_NAME"
    docker network create --driver bridge $NETWORK_NAME
else
    echo "Docker network $NETWORK_NAME already exists"
fi

# Create Docker volumes
if ! docker volume inspect "${ENV_NAME}_pg_data" >/dev/null 2>&1; then
    docker volume create "${ENV_NAME}_pg_data"
else
    echo "Docker volume ${ENV_NAME}_pg_data already exists"
fi

if ! docker volume inspect "${ENV_NAME}_minio_data" >/dev/null 2>&1; then
    docker volume create "${ENV_NAME}_minio_data"
else
    echo "Docker volume ${ENV_NAME}_minio_data already exists"
fi

# Now we add environment variables to the .env files
## 01_network/.env
rm -f ./01_network/.env
if [ ! -f ./01_network/.env ]; then
    echo "# The stack name" > ./01_network/.env
    echo "COMPOSE_PROJECT_NAME=milvue-reverse-proxy" > ./01_network/.env
fi
echo "NETWORK_NAME=$NETWORK_NAME" >> ./01_network/.env
echo "DOMAIN_NAME=$DOMAIN_NAME" >> ./01_network/.env
echo "ACME_EMAIL=$ACME_EMAIL" >> ./01_network/.env

## 02_database/.env
rm -f ./02_database/.env
if [ ! -f ./02_database/.env ]; then
    echo "# The stack name" > ./02_database/.env
    echo "COMPOSE_PROJECT_NAME=milvue-database" > ./02_database/.env
fi
echo "NETWORK_NAME=$NETWORK_NAME" >> ./02_database/.env
echo "ENV_NAME=$ENV_NAME" >> ./02_database/.env
echo "DOCKER_IMAGE_TAG=$DOCKER_IMAGE_TAG" >> ./02_database/.env
echo "ADMIN_TOKEN=$ADMIN_TOKEN" >> ./02_database/.env

## 03_ai_engine/.env
rm -f ./03_ai_engine/.env
if [ ! -f ./03_ai_engine/.env ]; then
    echo "# The stack name" > ./03_ai_engine/.env
    echo "COMPOSE_PROJECT_NAME=milvue-ai-engine" > ./03_ai_engine/.env
fi
echo "DOMAIN_NAME=$DOMAIN_NAME" >> ./03_ai_engine/.env
echo "NETWORK_NAME=$NETWORK_NAME" >> ./03_ai_engine/.env
echo "ENV_NAME=$ENV_NAME" >> ./03_ai_engine/.env
echo "DOCKER_IMAGE_TAG=$DOCKER_IMAGE_TAG" >> ./03_ai_engine/.env
echo "ADMIN_TOKEN=$ADMIN_TOKEN" >> ./03_ai_engine/.env
echo "DEVICE=$DEVICE" >> ./03_ai_engine/.env
echo "AUTHENTICATION_KEY=$AUTHENTICATION_KEY" >> ./03_ai_engine/.env

