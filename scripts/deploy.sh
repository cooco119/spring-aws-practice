#!/bin/bash

REPOSITORY=/home/ec2-user/app
PROJECT_NAME=spring-aws-practice
IMAGE=629446280937.dkr.ecr.ap-northeast-2.amazonaws.com/spring-aws-practice
IMAGE_TAG=latest

PORT=8080
CONFIG_PATH=$REPOSITORY/configs/
CONTAINER_INTERNAL_CONFIG_DIR=/config/
CONTAINER_INTERNAL_CONFIG_PATH=$CONTAINER_INTERNAL_CONFIG_DIR/application-oauth.properties,\
$CONTAINER_INTERNAL_CONFIG_DIR/application-prod-db.properties

cd $REPOSITORY

echo "> Pull docker image"

sudo docker pull $IMAGE:$IMAGE_TAG

echo "> Starting image"

sudo docker run --restart always -d -p $PORT:$PORT -v $CONFIG_PATH:$CONTAINER_INTERNAL_CONFIG_DIR \
-e CONFIG_PATH=$CONTAINER_INTERNAL_CONFIG_PATH $IMAGE:$IMAGE_TAG