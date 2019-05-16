#!/bin/bash
while read line;
do
  if [ $(echo $line | wc -c) -lt "3" ]; then
    break
  fi
done

proc_chk=$(pidof fetchmail)

# Status code
if [ -z "${proc_chk}" ]; then
        echo HTTP/1.1 404 Not Found
        response="<html><body>inactive</body></html>"
        length=$(echo $response | wc -c)
else
        echo HTTP/1.0 200 OK
        response="<html><body>active</body></html>"
        length=$(echo $response | wc -c)
fi

# Headers and response
echo "Content-Type: text/html; charset=utf-8"
echo "Connection: close"
echo "Content-Length: $length"
echo
echo $response
