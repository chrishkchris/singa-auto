#!/usr/bin/env bash
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

LOG_FILE_PATH=$PWD/$LOGS_DIR_PATH/start_kafka.log

source ./scripts/docker_swarm/utils.sh

title "Starting SINGA-Auto's Kafka..."

# docker container run flags info:
# --rm: container is removed when it exits
# (--rm will also remove anonymous volumes)
# -v == --volume: shared filesystems
# -e == --env: environment variable
# --name: name used to identify the container
# --network: default is docker bridge
# -p: expose and map port(s)

(docker run --rm --name $KAFKA_HOST \
  --network $DOCKER_NETWORK \
  -e KAFKA_ZOOKEEPER_CONNECT=$ZOOKEEPER_HOST:$ZOOKEEPER_PORT \
  -e KAFKA_ADVERTISED_HOST_NAME=$KAFKA_HOST \
  -e KAFKA_ADVERTISED_PORT=$KAFKA_PORT \
  -e KAFKA_MESSAGE_MAX_BYTES=134217728\
  -e KAFKA_FETCH_MAX_BYTES=134217728\
  -p $KAFKA_EXT_PORT:$KAFKA_PORT \
  -d $IMAGE_KAFKA \
  &> $LOG_FILE_PATH) &
ensure_stable "SINGA-Auto's Kafka" $LOG_FILE_PATH 2
