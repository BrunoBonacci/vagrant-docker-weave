#!/bin/bash

if [ "$(id -u)" != "0" ] ; then
  echo 'ERROR: you have to run this script as root user.'
  exit 1
fi

function contid(){
   echo "$1" | sed 's/^\(.\{12\}\).*/\1/'
}

# starting the wave daemon
weave launch 20.20.20.21

# starting the container with the specific IP
CNT2=$( contid $(weave run 10.10.1.2/24 -t -i ubuntu))
CNT3=$( contid $(weave run 10.10.2.1/24 -t -i ubuntu))


echo "
| Container | IP           | Container Id |
|-----------+--------------+--------------|
| cnt2      | 10.10.1.2/24 | $CNT2 |
| cnt3      | 10.10.2.1/24 | $CNT3 |
"
echo "now you can attach the session with:"
echo "docker attach [CntID]"
