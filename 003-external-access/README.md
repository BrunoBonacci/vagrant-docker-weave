# External access to the SDN

## Exposing the container (Weave) network to the host network.

In this exaple we are creating a SDN of 3 containers into 3 separate nodes which
are all places into a single subnet `10.10.1.0/24`. The subnet by default
is not accessible by the outside world, here whe bridge the two networks
and expose an internal service to the external network.


```

    20.20.20.21                   20.20.20.22                   20.20.20.23
    ...--+-----------------------------+------------------------------+--...
         |                             |                              | 
 +----------------+            +----------------+            +----------------+
 |                |            |                |            |                |
 |                |            |                |            |                |
 |      10.10.1.1 |            |    10.10.1.2   |            |  10.10.1.3     |
 |          /----------+---------------+-----------------------------\        |
 |      --------  |    |       |   --------     |            |   ----------   |
 |      | cnt1 |  |    |       |   | cnt2 |     |            |   |  cnt3  |   |
 |      --------  |    |       |   --------     |            |   |nginx:80|   |
 |                |    |       |                |            |   ----------   |
 +----------------+    |       +----------------+            +----------------+
       node1   \-------+              node2                         node3
              10.10.1.100

```

To setup this environment run the following commands

    node1$ sudo /vagrant/003-external-access/weave-host1.sh
    
    node2$ sudo /vagrant/003-external-access/weave-host2.sh
    
    node3$ sudo /vagrant/003-external-access/weave-host3.sh


In this case we are exposing the internal network `10.10.1.0/24` to the `node1` host environment.
Weave will add a new network interface on `node1` called `wave` with the addess of `10.10.1.100`.

Here we can see the interface added in `node1`:

```
weave     Link encap:Ethernet  HWaddr 7a:82:6e:92:ff:72
          inet addr:10.10.1.100  Bcast:0.0.0.0  Mask:255.255.255.0
          inet6 addr: fe80::7882:6eff:fe92:ff72/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:65535  Metric:1
          RX packets:215 errors:0 dropped:0 overruns:0 frame:0
          TX packets:101 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:12232 (12.2 KB)  TX bytes:7078 (7.0 KB)
```

additionally there will be a new route to be able to route packets to the internal subnet
via this network interface.

```
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
10.10.1.0       *               255.255.255.0   U     0      0        0 weave
...
```

This is achieved in the script by running:

    node1$ sudo weave expose 10.10.1.100/24

At this point we can from `node1`, outside of a container ping *ALL* the containers
in the network `10.10.1.0/24`, even those in a different node.

For example since the `cnt3` is running a `nginx` we can access it by running:

    node1$ curl -i http://10.10.1.3/

__Note: the nginx is running in the cnt3 which is running in node3__

This configuration can be useful in cases where a portion of our physical network
is in a DMZ, or is the only part accessible by the outside world.
For example we could put `node1` behind a load-balancer and forward the traffic.

To achieve this we need to add a NAT rule to route the traffic from the extern (LB)
to the internal network:

    node1$ sudo iptables -t nat -A PREROUTING -p tcp -i eth1 --dport 80 -j DNAT --to-destination 10.10.1.3:80

Now we can access the `nginx` in `cnt3/node3` event from the host machine or external network:

    $ curl -i http://20.20.20.21/

__Note: because of the way the iptables process the PREROUTING rules, this won't work from inside `node1`__,
but it will be accessible from everywhere else. To be able to access it even from `node1` you can either
use the internal container ip `curl -i http://10.10.1.3` or add the following NAT rule.

    node1$ sudo iptables -t nat -A OUTPUT -p tcp --dport 80 -j DNAT --to-destination 10.10.1.3:80

One interesting fact is that the container with `nginx` could be killed and restarted somewhere else
with the same IP, and everything will be still working. This might be useful in case of failures of `node3`.

## Exposing the host network to the container (Weave) network

In the previous example we have seen how to make the rest of the world interact with the container's network.
Here we will see how to do the other way round. For example let's assume that you have a database which
isn't containeraised and it is accessible only by the host network (`20.20.20.*/24`) or even more
restrictively is accessible only by one node (`node2`); what we want is our containers to be able to access
this service.

For the purpose of this example let's assume that the service accessible only by `node2` is another
webservice instance which is running on the `localhost` binding interface of `node2` (and only accessible
by `node2`)

```

    20.20.20.21                   20.20.20.22                   20.20.20.23
    ...--+-----------------------------+------------------------------+--...
         |                             |                              | 
 +----------------+            +----------------+            +----------------+
 |                |            |                |            |                |
 |                |            |                |            |                |
 |      10.10.1.1 |            |    10.10.1.2   |            |  10.10.1.3     |
 |          /----------+---------------+-------------+---------------\        |
 |      --------  |    |       |   --------     |    |       |   ----------   |
 |      | cnt1 |  |    |       |   | cnt2 |     |    |       |   |  cnt3  |   |
 |      --------  |    |       |   --------     |    |       |   |nginx:80|   |
 |                |            |                |    |       |                |
 |                |    |       | 127.0.01:8888  |    |       |   ----------   |
 +----------------+    |       +----------------+    |       +----------------+
       node1   \-------+              node2  \-------+             node3
              10.10.1.100                    10.10.1.200

```

To setup this environment follow the steps described above and then run:

    node2$ /vagrant/003-external-access/weave-host2b.sh

this will start a web server on `127.0.0.1:8888` which can be verified with

    node2$ netstat -nl | grep 8888
    tcp        0      0 127.0.0.1:8888          0.0.0.0:*               LISTEN

therefore this service will be accessible only by this node.
Now lets assume we need to provide access to this service to all containers,
to do so we will need to `import` the service in the weave network.

    node2$ sudo weave expose 10.10.1.200/24

Now we need to route packets to this ip address to the local service:

    node2$ sudo iptables -t nat -A PREROUTING -p tcp -d 10.10.1.200 --dport 8888 -j DNAT --to-destination 127.0.0.1:8888
    node2$ sudo iptables -t nat -A POSTROUTING -p tcp --dst 127.0.0.1 --dport 8888 -j SNAT --to-source 10.10.1.200

Now the service in `node2` is accessible by Weave network via the `10.10.1.200` ip address.

This it can be vary usefull to connect part of your infrastructure which are in pre-existing server installation outside
of the container management.

