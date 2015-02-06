Simple network

In this exaple we are creating a SDN of 3 containers into 3 separate nodes which
are all places into a single subnet `10.10.1.0/24`


```

    20.20.20.21                   20.20.20.22                   20.20.20.23
    ...--+-----------------------------+------------------------------+--...
         |                             |                              | 
 +----------------+            +----------------+            +----------------+
 |                |            |                |            |                |
 |                |            |                |            |                |
 |      10.10.1.1 |            |    10.10.1.2   |            |  10.10.1.3     |
 |          /--------------------------+-----------------------------\        |
 |      --------  |            |   --------     |            |   --------     |
 |      | cnt1 |  |            |   | cnt2 |     |            |   | cnt3 |     |
 |      --------  |            |   --------     |            |   --------     |
 |                |            |                |            |                |
 +----------------+            +----------------+            +----------------+
       node1                         node2                         node3

```

In this case the containers `cnt1`, `cnt2` and `cnt3` can communicate between each other
in total isolation from the `20.20.20.*` network, and they can be addressed by their
ip independetly fron their position (node) in the cluster.

For example you can start the `cnt3` from the node two as well and still maintain
the same ip `10.10.1.3`

```

    20.20.20.21                   20.20.20.22                   20.20.20.23
    ...--+-----------------------------+------------------------------+--...
         |                             |                              | 
 +----------------+            +----------------+            +----------------+
 |                |            |                |            |                |
 |                |            |                |            |                |
 |      10.10.1.1 |            |    10.10.1.2   |            |                |
 |          /-----------+--------------+        |            |                |
 |      --------  |     |      |   --------     |            |                |
 |      | cnt1 |  |     |      |   | cnt2 |     |            |                |
 |      --------  |     |      |   --------     |            |                |
 |                |     |      |   --------     |            |                |
 |                |     \----------| cnt3 |     |            |                |
 |                |            |   --------     |            |                |
 |                |            |    10.10.1.3   |            |                |
 +----------------+            +----------------+            +----------------+
       node1                         node2                         node3

```

Each container is addressable with its IP independetly from the physical localtion.

