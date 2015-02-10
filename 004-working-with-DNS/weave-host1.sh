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

# starting the weave DNS
DNS=$( contid $(weave launch-dns 10.10.254.1/24))

# starting the container with the specific IP
C1=$( contid $(weave run --with-dns 10.10.1.1/24 -t -i -h cnt1.weave.local ubuntu))
C2=$( contid $(weave run --with-dns 10.10.1.4/24 -t -i -h cnt4.weave.local ubuntu))

echo "
| Container | IP             | Container Id | DNS name         |
|-----------+----------------+--------------|------------------|
| dns1      | 10.10.254.1/24 | $DNS |                  |
| cnt1      | 10.10.1.1/24   | $C1 | cnt1.weave.local |
| cnt4      | 10.10.1.4/24   | $C2 | cnt4.weave.local |
"
echo "now you can attach the session with:"
echo "docker attach [CntID]"
