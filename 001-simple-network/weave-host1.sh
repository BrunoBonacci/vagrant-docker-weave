#!/bin/bash
if [ "$(id -u)" != "0" ] ; then
  echo 'ERROR: you have to run this script as root user.'
  exit 1
fi

# starting the wave daemon
weave launch

# starting the container with the specific IP
C=$(weave run 10.10.1.1/24 -t -i ubuntu)

echo "container running on 10.10.1.1 : $C"
echo "now you can attach the session with:"
echo "docker attach $C"
