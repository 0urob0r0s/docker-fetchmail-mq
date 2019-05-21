# Distributed Fetchmail based POP3 to MQ Gateway

 **Overview**

This container was made to provide highly available and distributed fetchmail services for Request Tracker.
Fully configurable through ENV variables, it will fetch and publish POP3 emails into a RabbitMQ Server.

**Caveats**

Only POP3 supported at this time, fully tested with gmail.com services.

**Features**

- Fully configurable through Docker ENV vars
- RabbitMQ support
- Autoconfiguration available if linked to 0urob0r0s/rancher-auto-rabbitmq
- Nodes with integrated healhcheck for self-healing, recovery.

**Usage**

*Example Docker Compose - Multinode Distributed deployment*

```
version: '2'
services:
  Fetchmail:
    image: docker-fetchmail-mq:latest
    environment:
      FETCH_USERS: firstuser@mailserver.com seconduser@mailserver.com
      FETCH_PASS: firstpassword secondpassword
      FETCH_QUEUES: firstQueue secondQueue
      FETCH_QUEUES_TYPE: correspond comment
      FETCH_EXCHANGE: rt4.exchange
      FETCH_SYNC: '10'
      FETCH_TIMEOUT: '10'
      FETCH_POP3_SERVER: pop.gmail.com
      FETCH_EXTRA: --verbose
      FETCH_MQ_USER: userMQ
      FETCH_MQ_PASS: passMQ
      FETCH_MQ_HOST: 1.2.3.4
      FETCH_MQ_PORT: 5672
    stdin_open: true
    volumes:
    - /opt/volumes/fetchmail:/opt
    tty: true
    labels:
      io.rancher.scheduler.global: 'true'
```

*Example Rancher Compose - Healthcheck Settings*

```
version: '2'
services:
  Fetchmail:
    start_on_create: true
    health_check:
      healthy_threshold: 2
      response_timeout: 2000
      port: 9090
      unhealthy_threshold: 3
      initializing_timeout: 60000
      interval: 2000
      strategy: recreate
      request_line: GET "/" "HTTP/1.0"
      reinitializing_timeout: 60000
```

**Notes**

FETCH_USERS, FETCH_PASS and FETCH_QUEUES are array variables.
 - Elements are separated by spaces.
 - Elements with space in the name go inside single quotes: 'an element'.

FETCH_SYNC = How often Fetchmail will check for new mails (in seconds).


**Head over the repo `docker-adv-rt` for a more complex example.**

