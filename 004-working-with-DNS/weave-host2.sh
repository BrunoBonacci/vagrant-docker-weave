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

# starting the weave DNS
DNS=$( contid $(weave launch-dns 10.10.254.2/24))

# starting the container with the specific IP
C1=$( contid $(weave run --with-dns 10.10.1.2/24 -t -i -h cnt2.weave.local ubuntu))
C2=$( contid $(weave run --with-dns 10.10.1.5/24 -t -i -h cnt5.weave.local ubuntu))

echo "
| Container | IP             | Container Id | DNS name         |
|-----------+----------------+--------------|------------------|
| dns2      | 10.10.254.2/24 | $DNS |                  |
| cnt2      | 10.10.1.2/24   | $C1 | cnt2.weave.local |
| cnt5      | 10.10.1.5/24   | $C2 | cnt5.weave.local |
"
echo "now you can attach the session with:"
echo "docker attach [CntID]"
