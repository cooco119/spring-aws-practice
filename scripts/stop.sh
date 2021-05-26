#!/usr/bin/env bash

ABSPATH=$(readlink -f $0)
ABSDIR=$(dirname $ABSPATH)
source ${ABSDIR}/profile.sh

$IDLE_PROFILE=$(find_idle_profile)

echo "> Trying to stop container spring-aws-practice-$IDLE_PROFILE"
docker kill spring-aws-practice-$IDLE_PROFILE
sleep 5
