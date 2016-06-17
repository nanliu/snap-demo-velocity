#!/bin/bash

#http://www.apache.org/licenses/LICENSE-2.0.txt
#
#
#Copyright 2015 Intel Corporation
#
#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.

# add some color to the output
red=$(tput setaf 1)
green=$(tput setaf 2)
reset=$(tput sgr0)

die () {
  echo >&2 "${red} $@ ${reset}"
  exit 1
}

dm_ip="127.0.0.1"

#start containers
docker-compose up -d

echo -n "waiting for influxdb and grafana to start"

# wait for influxdb to start up
while ! curl --silent -G "http://${dm_ip}:8086/query?u=admin&p=admin" --data-urlencode "q=SHOW DATABASES" 2>&1 > /dev/null ; do
  sleep 1
  echo -n "."
done
echo ""

#influxdb IP
influx_ip=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' influxdbgrafana_influxdb_1)
echo "influxdb ip: ${influx_ip}"

# create snap database in influxdb
curl -G "http://${dm_ip}:8086/ping"
echo -n ">>deleting snap influx db (if it exists) => "
curl -G "http://${dm_ip}:8086/query?u=admin&p=admin" --data-urlencode "q=DROP DATABASE snap"
echo ""
echo -n "creating snap influx db => "
curl -G "http://${dm_ip}:8086/query?u=admin&p=admin" --data-urlencode "q=CREATE DATABASE snap"
echo ""

# create influxdb datasource in grafana
echo -n "${green}adding influxdb datasource to grafana => ${reset}"
COOKIEJAR=$(mktemp)
curl -H 'Content-Type: application/json;charset=UTF-8' \
  --data-binary '{"user":"admin","email":"","password":"admin"}' \
  --cookie-jar "$COOKIEJAR" \
  "http://${dm_ip}:3000/login"

curl --cookie "$COOKIEJAR" \
  -X POST \
  --silent \
  -H 'Content-Type: application/json;charset=UTF-8' \
  --data-binary "{\"name\":\"influx\",\"type\":\"influxdb\",\"url\":\"http://${influx_ip}:8086\",\"access\":\"proxy\",\"database\":\"snap\",\"user\":\"admin\",\"password\":\"admin\"}" \
  "http://${dm_ip}:3000/api/datasources"
echo ""

dashboard=$(cat /vagrant/influxdb-grafana/grafana/psutil.json)
curl --cookie "$COOKIEJAR" \
  -X POST \
  --silent \
  -H 'Content-Type: application/json;charset=UTF-8' \
  --data "$dashboard" \
  "http://${dm_ip}:3000/api/dashboards/db"
echo ""

echo -n "${greeN}adding task${reset}"
TMPDIR=${TMPDIR:="/vagrant/tmp"}
mkdir -p ${TMPDIR}
TASK="${TMPDIR}/snap-task-$$.json"
echo "$TASK"
cat /vagrant/influxdb-grafana/psutil-influx.json | sed s/INFLUXDB_IP/${dm_ip}/ > $TASK
