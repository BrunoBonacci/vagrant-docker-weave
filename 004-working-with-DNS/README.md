# DNS network setup

In this exaple we are creating a SDN of 6 containers into 3 separate nodes which
are all places into a single subnet `10.10.1.0/24`


```

    20.20.20.21                   20.20.20.22                   20.20.20.23
    ...--+-----------------------------+------------------------------+--...
         |                             |                              | 
 +----------------+            +----------------+            +----------------+
 |                |            |                |            |                |
 |                |            |                |            |                |
 |    10.10.254.1 |            |  10.10.254.2   |            | 10.10.254.3    |
 |          /--------------------------+-----------------------------\        |
 |      --------  |            |   --------     |            |   --------     |
 |   *==| dns1 |  |            |   | dns2 |==*  |            |   | dns3 |==*  |
 |   "  --------  |            |   --------  "  |            |   --------  "  |
 |   "            |            |             "  |            |             "  |
 |   "  10.10.1.1 |            |   10.10.1.2 "  |            |  10.10.1.3  "  |
 |   "      /--------------------------+-----------------------------+-------------\
 |   "  --------  |            |   --------  "  |            |   --------  "  |    |
 |   *==| cnt1 |  |            |   | cnt2 |==*  |            |   | cnt3 |==*  |    |
 |   "  --------  |            |   --------  "  |            |   --------  "  |    |
 |   "            |            |             "  |            |             "  |    |
 |   "  --------  |            |   --------  "  |            |   --------  "  |    |
 |   *==| cnt4 |  |            |   | cnt5 |==*  |            |   | cnt6 |==*  |    |
 |      --------  |            |   --------     |            |   --------     |    |
 |          /--------------------------+-----------------------------+-------------/
 |      10.10.1.4 |            |    10.10.1.5   |            |  10.10.1.6     |
 |                |            |                |            |                |
 +----------------+            +----------------+            +----------------+
       node1                         node2                         node3

```

To setup this environment run the following commands

    node1$ sudo /vagrant/004-working-with-DNS/weave-host1.sh
    
    node2$ sudo /vagrant/004-working-with-DNS/weave-host2.sh
    
    node3$ sudo /vagrant/004-working-with-DNS/weave-host3.sh


A DNS container needs to be started in each node.
A different network is used for the DNS, each DNS is in a separate container.
Each DNS in each node resolves the names for the container in that node.
Since the container subnet is completely isolated from the DNS network,
Weave leverages the default Docker's network to communicate within a single node.
In other words, containers in each node use the Docker's network to reach,
a local instance of a DNS which is responsible for resolving the names of
the local containers. If the container's name can't be resolved by the local
DNS, then the Weave's network is used to reach the other DNS instances in other
nodes. Beacuse Weave uses the Docker's network for `in-node` communication,
we can't disable it (no `--net=node`).

This, in my opinion, is not ideal, in fact one reason for using the Weave
network is to be able to design network topologies which span across
nodes and the only mean of communication. The advantage of this option
is what we can easily set subnet ACL rules for each container without
having to care about additional bridged networks.

Now because of this strategy if you kill one of the dns instances,
the containers in that node won't be resolvable anymore.
This unfortunately for me is a major problem, as until you don't restart
the DNS container all other containers won't be resolvable.

There are other limitations described in the
[Weave README](https://github.com/zettio/weave/tree/master/weavedns#readme) page.

The domain `weave.local` is just the default if no others are proviced.
You can specify your own domain name (including sub-zones) and other search paths
by running:

```
node1$ sudo weave run --with-dns 10.10.1.1/24 -ti \
            --dns-search=db.mynet.priv --dns-search=web.mynet.priv \
            --dns-search=mynet.priv \
            -h db1.db.mynet.priv ubuntu
```

and on a different node.

```
node2$ sudo weave run --with-dns 10.10.1.2/24 -ti \
            --dns-search=db.mynet.priv --dns-search=web.mynet.priv \
            --dns-search=mynet.priv \
            -h web1.web.mynet.priv ubuntu
```

This should set the correct hostname and the adequate DNS search path in `/etc/resolv.conf`
