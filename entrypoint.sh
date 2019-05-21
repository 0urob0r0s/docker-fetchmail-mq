#!/bin/bash

set -e

fetch_conf=/opt/fetchmailrc.conf
 
declare -a array_user=(${FETCH_USERS})
declare -a array_pass=(${FETCH_PASS})
declare -a array_queue=(${FETCH_QUEUES})
declare -a array_type=(${FETCH_QUEUES_TYPE})


exchange_rt4=${FETCH_EXCHANGE}

amqp_connect="amqp://${FETCH_MQ_USER:-${RABBITMQ_ENV_RABBITMQ_DEFAULT_USER:-guest}}:${FETCH_MQ_PASS:-${RABBITMQ_ENV_RABBITMQ_DEFAULT_PASS:-guest}}@${FETCH_MQ_HOST:-rabbitmq}:${FETCH_MQ_PORT:-5672}"
max_iteration=${#array_user[@]}

### Generate Server connection string
echo "poll ${FETCH_POP3_SERVER}  proto pop3:" > ${fetch_conf}

### Generate FetchMail Queues
for i in $(seq 0 $((max_iteration-1))); do

	if [ "${array_type[$i]}" = "comment" ]; then
		echo "username ${array_user[$i]} password ${array_pass[$i]}  mda \"/usr/bin/amqp-publish -e '${exchange_rt4}' -r '${array_queue[$i]}' --url='${amqp_connect}/comment'\" options ssl" >> ${fetch_conf}
	else
		echo "username ${array_user[$i]} password ${array_pass[$i]}  mda \"/usr/bin/amqp-publish -e '${exchange_rt4}' -r '${array_queue[$i]}' --url='${amqp_connect}/correspond'\" options ssl" >> ${fetch_conf}
	fi

done 

chmod 0700 ${fetch_conf}

exec "$@"
