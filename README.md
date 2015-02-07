# vagrant-docker-weave

Multi nodes vagrant setup for docker and weave testing

This Vagrant project allows you to easily setup and test multiple
configuration of Docker and Weave.

`vagrant-docker-weave` repo available at: [https://github.com/BrunoBonacci/vagrant-docker-weave](https://github.com/BrunoBonacci/vagrant-docker-weave)


Authors:

  - Bruno Bonacci

## Documentation conversions

We will have to execute a number of different commands in different boxes.
To easily identify which box are we referring to we will follow this convension:

    $ echo "this is the host machine, like your laptop"
    node2$ echo "this is a command to execute in the Vagrant node2"
    cnt1$ echo "this command is to be run inside the container1"

To ssh into any of the three nodes just type:

    $ vagrant ssh <node_name>
    
Example, to ssh into node 3 type:

    $ vagrant ssh node3

To access a specific container first you need to ssh into the node which is hosting
the container, then run

    $ docker attach <container-id>

the `container-id` can be retrieved with

    $ docker ps

## Usage

You can start the cluster of nodes with:

    $ vagrant up

This will start 3 nodes with a host-only network set up on `20.20.20.21/24`.
Every node will `have docker` and `weave` pre-installed.

For a more interative session I do suggest to open at least three independent terminal windows
and ssh into all three nodes.
Then you can choose any of the following sample and run the node setup scripts.

  * [Simple network](001-simple-network) - single network with three containers on a private network
  * [Two isolated networks](002-isolated-networks) - two networks which are isolated from each other.
  * [Exposing a network](003-external-access) - how to give access to a network from the outside world.

## License

Copyright © 2015 B. Bonacci

Distributed under the Apache License v 2.0 (http://www.apache.org/licenses/LICENSE-2.0)
