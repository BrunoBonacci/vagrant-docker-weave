# Isolated networks

In this exaple we are creating a SDN of 4 containers into 3 separate nodes which
are all places into two isolated subnets `10.10.1.0/24` and `10.10.2.0/24`


```

    20.20.20.21                   20.20.20.22                   20.20.20.23
    ...--+-----------------------------+------------------------------+--...
         |                             |                              |
 +----------------+            +----------------+            +----------------+
 |                |            |                |            |                |
 |                |            |                |            |                |
 |      10.10.1.1 |            |    10.10.1.2   |            |                |
 |          /--------------------------\        |            |                |
 |      --------  |            |   --------     |            |                |
 |      | cnt1 |  |            |   | cnt2 |     |            |                |
 |      --------  |            |   --------     |            |                |
 |                |            |                |            |                |
 |                |            |                |            |                |
 |                |            |    10.10.2.1   |            |  10.10.2.2     |
 |                |            |       /-----------------------------\        |
 |                |            |   --------     |            |   --------     |
 |                |            |   | cnt3 |     |            |   | cnt4 |     |
 |                |            |   --------     |            |   --------     |
 |                |            |                |            |                |
 +----------------+            +----------------+            +----------------+
       node1                         node2                         node3

```

To setup this environment run the following commands

    node1$ sudo /vagrant/002-isolated-networks/weave-host1.sh
    
    node2$ sudo /vagrant/002-isolated-networks/weave-host2.sh
    
    node3$ sudo /vagrant/002-isolated-networks/weave-host3.sh

In this case the containers `cnt1`, and `cnt2` can communicate between each other
in total isolation from the `20.20.20.*` network, and they can be addressed by their
ip independetly fron their position (node) in the cluster.
Same thing is valid for the second group of containers `cnt3` and `cnt4`.
However there is no connection between the two groups `cnt1-2` cannot communicate
with `cnt3-4`.

For example from `cnt3` you will be able to ping `cnt4` but not `cnt1` and `cnt2`
and vice-versa. This is good solution to provide network isolation for different
apps or environments (dev/test/prod) using the same physical nodes.


