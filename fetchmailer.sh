#!/bin/bash
set -e
touch /opt/fetchmail.log
/usr/bin/fetchmail --daemon ${FETCH_SYNC:-30} --logfile /opt/fetchmail.log --timeout ${FETCH_TIMEOUT:-10} --fetchmailrc /opt/fetchmailrc.conf ${FETCH_EXTRA}
