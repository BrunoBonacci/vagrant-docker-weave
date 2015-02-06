# vagrant-docker-weave

Multi nodes vagrant setup for docker and weave testing

This Vagrant project allows you to easily setup and test multiple
configuration of Docker and Weave.

`vagrant-docker-weave` repo available at: [https://github.com/BrunoBonacci/vagrant-docker-weave](https://github.com/BrunoBonacci/vagrant-docker-weave)


Authors:

  - Bruno Bonacci

## Usage

You can start the cluster of nodes with:

    $ vagrant up

This will start 3 nodes with a host-only network set up on `20.20.20.21/24`.
Every node will `have docker` and `weave` pre-installed.

The you can choose any of the following sample and run the node setup scripts.

  * [Simple network](001-simple-network) - single network with three containers on a private network

## License

Copyright © 2014 B. Bonacci

Distributed under the Apache License v 2.0 (http://www.apache.org/licenses/LICENSE-2.0)
