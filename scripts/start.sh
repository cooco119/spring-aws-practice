#!/usr/bin/env bash

ABSPATH=$(readlink -f $0)
ABSDIR=$(dirname $ABSPATH)
source ${ABSDIR}/profile.sh

REPOSITORY=/home/ec2-user/app
PROJECT_NAME=spring-aws-practice
IMAGE=629446280937.dkr.ecr.ap-northeast-2.amazonaws.com/spring-aws-practice
IMAGE_TAG=latest

IDLE_PROFILE=$(find_idle_profile)
PORT=8080
if [ $IDLE_PROFILE == prod1 ]; then
  PORT=8081
else
  PORT=8082
fi
CONFIG_PATH=$REPOSITORY/configs/
CONTAINER_INTERNAL_CONFIG_DIR=/config/


CONTAINER_INTERNAL_CONFIG_PATH=classpath:/application-$IDLE_PROFILE.properties,\
$CONTAINER_INTERNAL_CONFIG_DIR/application-oauth.properties,\
$CONTAINER_INTERNAL_CONFIG_DIR/application-prod-db.properties

cd $REPOSITORY

echo "> Login to ECR"

aws ecr get-login-password --region ap-northeast-2 | docker login --username AWS --password-stdin 629446280937.dkr.ecr.ap-northeast-2.amazonaws.com

echo "> Pull docker image"

docker pull $IMAGE:$IMAGE_TAG

echo "> Starting image with profile ${IDLE_PROFILE} on port ${PORT}"

docker run -d -p $PORT:$PORT -v $CONFIG_PATH:$CONTAINER_INTERNAL_CONFIG_DIR \
-e CONFIG_PATH=$CONTAINER_INTERNAL_CONFIG_PATH -e PROFILE=$IDLE_PROFILE --name spring-aws-practice-$IDLE_PROFILE $IMAGE:$IMAGE_TAG