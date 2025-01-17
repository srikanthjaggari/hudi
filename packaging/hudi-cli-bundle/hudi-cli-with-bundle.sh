#!/usr/bin/env bash

#  Licensed to the Apache Software Foundation (ASF) under one
#  or more contributor license agreements.  See the NOTICE file
#  distributed with this work for additional information
#  regarding copyright ownership.  The ASF licenses this file
#  to you under the Apache License, Version 2.0 (the
#  "License"); you may not use this file except in compliance
#  with the License.  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
# limitations under the License.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "DIR is ${DIR}"
CLI_BUNDLE_JAR=`ls $DIR/target/hudi-cli-bundle*.jar | grep -v source | grep -v javadoc`
SPARK_BUNDLE_JAR=`ls $DIR/../hudi-spark-bundle/target/hudi-spark*-bundle*.jar | grep -v source | grep -v javadoc`
HUDI_CONF_DIR="${DIR}"/conf
# hudi aux lib contains jakarta.el jars, which need to be put directly on class path
HUDI_AUX_LIB="${DIR}"/auxlib

. "${DIR}"/conf/hudi-env.sh

if [ -z "$CLI_BUNDLE_JAR" ] || [ -z "$SPARK_BUNDLE_JAR" ]; then
  echo "Make sure to generate both the hudi-cli-bundle.jar and hudi-spark-bundle.jar before running this script."
  exit
fi

if [ -z "$SPARK_HOME" ]; then
  echo "SPARK_HOME not set, setting to /usr/local/spark"
  export SPARK_HOME="/usr/local/spark"
fi

if [ -z "$CLIENT_JAR" ]; then
  echo "Client jar location not set, please set it in conf/hudi-env.sh"
fi

echo "Running : java -cp ${HUDI_AUX_LIB}/*:${SPARK_HOME}/*:${SPARK_HOME}/jars/*:${HUDI_CONF_DIR}:${HUDI_AUX_LIB}/*:${HADOOP_CONF_DIR}:${SPARK_CONF_DIR}:${CLI_BUNDLE_JAR}:${SPARK_BUNDLE_JAR}:${CLIENT_JAR} -DSPARK_CONF_DIR=${SPARK_CONF_DIR} -DHADOOP_CONF_DIR=${HADOOP_CONF_DIR} org.apache.hudi.cli.Main $@"
java -cp ${HUDI_AUX_LIB}/*:${SPARK_HOME}/*:${SPARK_HOME}/jars/*:${HUDI_CONF_DIR}:${HADOOP_CONF_DIR}:${SPARK_CONF_DIR}:${CLI_BUNDLE_JAR}:${SPARK_BUNDLE_JAR}:${CLIENT_JAR} -DSPARK_CONF_DIR=${SPARK_CONF_DIR} -DHADOOP_CONF_DIR=${HADOOP_CONF_DIR} org.apache.hudi.cli.Main $@
