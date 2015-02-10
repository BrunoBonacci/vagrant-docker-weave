#!/bin/bash
if [ "$(id -u)" != "0" ] ; then
  echo 'ERROR: you have to run this script as root user.'
  exit 1
fi

function contid(){
   echo "$1" | sed 's/^\(.\{12\}\).*/\1/'
}

# starting the wave daemon
weave launch

# starting the container with the specific IP
C=$( contid $(weave run 10.10.1.1/24 --net=none -t -i ubuntu))

echo "
| Container | IP           | Container Id |
|-----------+--------------+--------------|
| cnt1      | 10.10.1.1/24 | $C |
"
echo "now you can attach the session with:"
echo "docker attach [CntID]"
