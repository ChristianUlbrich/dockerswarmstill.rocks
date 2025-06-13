<style>
.md-content .md-typeset h1 { display: none; }
</style>

<p align="center">
  <a href="https://dockerswarmstill.rocks"><img src="https://dockerswarmstill.rocks/img/logo-light-blue-vectors.svg" alt="dockerswarmstill.rocks"></a>
</p>

## Undeprecation Warning 🚨

**This website is undeprecated.**

It has been updated with some current recipes, because _Docker Swarm still rocks_. :)

See [Docker Swarm Mode or Kubernetes](swarm-or-kubernetes.md) for more information.

If you want to see alternative resources, you could check the [awesome-swarm](https://github.com/BretFisher/awesome-swarm) list for more resources about Docker Swarm Mode. 🤓

## Why?

<a href="https://www.docker.com/" target="_blank">Docker</a> is a great tool (the "de facto" standard) to build **Linux containers**.

<a href="https://docs.docker.com/compose/" target="_blank">Docker Compose</a> is great to **develop locally** with Docker, in a replicable way.

<a href="https://docs.docker.com/engine/swarm/" target="_blank">Docker Swarm Mode</a> is great to **deploy** your application stacks to **production**, in a **distributed cluster**, using the same files used by Docker Compose locally.

So, with Docker Swarm Mode you have:

* Reproducibility, use the same files as when developing locally.
* Simplicity and speed for development and deployment.
* Robustness and security, with fault-tolerant clusters.

## Docker Swarm mode

If you have Docker installed, you already have Docker Swarm, it's integrated into Docker.

You don't have to install anything else.

### Note

<blockquote>

<p>Whenever you read here "Docker Swarm" we are actually talking about "<strong>Docker Swarm mode</strong>".</p>

<p>Not the deprecated product called "Docker Swarm".</p>

</blockquote>

## Alternatives

Some of the main alternatives are:

* <a href="https://kubernetes.io/" target="_blank">Kubernetes</a>.
* <a href="https://mesos.apache.org/" target="_blank">Mesos</a>.
* <a href="https://developer.hashicorp.com/nomad" target="_blank">Nomad</a>.

To use any of them you need to learn a huge new set of concepts, configurations, files, commands, etc.

### About Docker Swarm mode

Docker Swarm mode is comparable to them.

But it, with all the ideas described here, is what I would recommend for teams of **less than 200 developers**, or clusters of **less than 1000 machines**.

This includes **small / medium size organizations** (like when you are not Google or Amazon), **startups**, one-man projects, and "hobby" projects.

Try it.

Set up a distributed cluster ready for production.

...In about **20 minutes**.

If it doesn't work for you, then you can go for Kubernetes, Mesos or any other.

Those are great tools. But learning them might take weeks. So, the **20 minutes spent here** are not much (and up to here you already spent 3 minutes).

## Single server

With Docker Swarm mode you can start with a "cluster" of a single server.

You can set it up, deploy your applications and do everything on a $5 USD/month server.

And then, when the time to grow comes, you can add more servers to the cluster.

With a **one-line command**.

And you can create your applications to be ready for massive scale from the beginning, starting from a single small server.

## About **Docker Swarm Still Rocks**

This is not associated with Docker or any of the tools suggested here.

It's mainly a set of ideas, documentation and tools to use existing open source products efficiently together.

Huge thanks to [@tiangolo](https://github.com/tiangolo) who originally created [dockerswarm.rocks](https://dockerswarm.rocks).

## Prerequisites

* To know some Linux.
* To know some Docker.

## Install and set up

### Install a new Linux server with Docker

* Create a new remote VPS ("virtual private server").
* Deploy the latest Ubuntu LTS ("long term support") version. At the time of this writing it's `Ubuntu 24.04`.
* Enable root or at least sudo _access_ to it and enable _password-less_ SSH key access.
> **Tip:** You can copy your own key to it, by using `ssh-copy-id root@your-cheapo-vps-ip`
* install latest [Docker](https://docs.docker.com/install/) on it, _Community Edition_ suffices
> **Tip:** You can do this easily by using [Ansible](https://docs.ansible.com/).
* Get either a brand-new _domain_ that still rocks (e.g. `dockerswarmstill.rocks`) or have a subdomain resolve to `your-cheapo-vps-ip` (e.g. `168.119.115.151`).
> **Tip:** Make sure, that you create both an A and an AAAA record. R.I.P. IpV4.

That's basically the only you ever do, directly on your VPS (apart from updates, of course!).

**Note:** The following is assuming, that there is no firewall at all in place on your VPS. Which is fine, if you are only exposing HTTP services.

### Setup remote docker access
From now on, you will be remotely controlling the running Docker engine on your VPS by your locally running (e.g. on your machine) Docker (client) CLI. You can _control_ any Docker engine, by setting the `DOCKER_HOST` _environment variable_, but it is much more convenient to use [Docker contexts](https://docs.docker.com/engine/manage-resources/contexts/):
```bash
 docker context create dockerswarmstillrocks --docker host=ssh://root@dockerswarmstill.rocks 
```
Listing contexts can be done with:
```bash
 docker context ls 
```
and you can use the newly created with:
```bash
docker context use dockerswarmstillrocks
```

### Set up swarm mode

In Docker Swarm Mode you have one or more "manager" nodes and one or more "worker" nodes. You `init` the first manager node and have other nodes `join` the swarm. You can control the whole swarm via remotely controlling on _manager_ node. So make sure, that you are using the proper context.

The first step is to configure one (or more) manager nodes.

```bash
docker swarm init
```

**Note**: if you see an error like:

```
Error response from daemon: could not choose an IP address to advertise since this system has multiple addresses on interface eth0 (198.51.100.48 and 10.19.0.5) - specify one with --advertise-addr
```

...select the public IP (e.g. `198.51.100.48` in this example), and run the command again with `--advertise-addr`, e.g.:

```bash
docker swarm init --advertise-addr 198.51.100.48
```

### Add manager nodes (optional)

* Using the `dockerswarmstillrocks` _context_, for each additional manager node you want to set up, run:

```bash
docker swarm join-token manager
```

* Copy the result and paste it in the **additional manager node's terminal**, it will be something like:

```bash
 docker swarm join --token SWMTKN-1-5tl7yaasdfd9qt9j0easdfnml4lqbosbasf14p13-f3hem9ckmkhasdf3idrzk5gz 192.0.2.175:2377
```

> **Tip:** Keep it simple first, if you want to distribute load, start with one manager and one worker node, add worker nodes as needed.

### Add worker nodes (optional)

* Using the `dockerswarmstillrocks` _context_, for each additional worker node you want to set up, run:

```bash
docker swarm join-token worker
```

* Copy the result and paste it in the **additional worker node's terminal**, it will be something like:

```bash
docker swarm join --token SWMTKN-1-5tl7ya98erd9qtasdfml4lqbosbhfqv3asdf4p13-dzw6ugasdfk0arn0 192.0.2.175:2377
```
> **Tip:** Do not bother setting up docker contexts on worker nodes. You only need them to join the swarm only once.

### Check it

* Check that the cluster has all the nodes connected and set up:

```bash
docker node ls
```

It outputs something like:

```
ID                            HOSTNAME                           STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
cck5z4w7f3yr74yrdvdtn9ogs *   dockerswarmstillrocks-4gb-nbg1-1   Ready     Active         Leader           28.2.2
```

### My first stack
In Docker Swam you `deploy` _stacks_ that consist of multiple containers, that are named _services_. Any _service_ can publish a _port_ on either _overlay networks_ or _directly_ on the host that the Docker engine is running. **Each** host-published port is automagically routed between swarm members.

> **Tip:** Don't you worry! You'll see in a minute, how things work together!

So let's deploy a simple container! We will be using [traefik/whoami](https://hub.docker.com/r/traefik/whoami) for that purpose:

* Download the file [stacks/whoami/docker-compose.yml](./stacks/whoami/docker-compose.yml):

```bash
curl -L dockerswarmstill.rocks/stacks/whoami/docker-compose.yml -o whoami.yml
```

* ...or create it manually, for example, using `nano`:

```bash
nano whoami.yml
```

* And copy the contents inside:

```YAML
{!./docs/stacks/whoami/docker-compose.yml!}
```
and _deploy_ the `whoami` _stack_
```bash
docker stack deploy -c whoami.yml whoami
```
> **Tip:** Make sure, you are controlling your Docker Swarm manager.

* See the _services_ of _stack_ `whoami`:

```bash
docker stack ps whoami
```
Which should output something like:
```
ID             NAME              IMAGE                   NODE                               DESIRED STATE   CURRENT STATE           ERROR     PORTS
c0ohzlts5x1x   whoami_whoami.1   traefik/whoami:latest   dockerswarmstillrocks-4gb-nbg1-1   Running         Running 2 minutes ago             
```
Remember either the DNS (e.g. `dockerswarmstill.rocks`) or the IP (e.g. `168.119.115.151`) of your VPS, so [give it a try](http://dockerswarmstill.rocks:1337):
```bash
curl dockerswarmstill.rocks:1337
```
Which should give you something like this:
```
Hostname: c8382051c434
IP: 127.0.0.1
IP: ::1
IP: 10.0.0.163
IP: 172.18.0.4
IP: 10.0.2.3
RemoteAddr: 10.0.0.2:54782
GET / HTTP/1.1
Host: dockerswarmstill.rocks:1337
User-Agent: curl/8.7.1
Accept: */*
```
## Done
That's it. Deployed! How about running the same thing _locally_?
```bash
docker context ls
docker context use desktop-linux
docker compose -f whoami.yml up
```
> **Tip:** Your "local" Docker context might have a different name. Look it up in the above list of contexts.

You have a (distributed) Docker swarm mode cluster set up and _deployed_ your very first _stack_, that you can run _locally_ from the **same** file!

/// note

You _might_ want to `rm` (oh no!) your freshly deployed `whoami` _stack_ with:
```bash
docker context use dockerswarmstillrocks
docker stack rm whoami
```
///

Check other sections in the documentation at [https://dockerswarmstill.rocks](https://dockerswarmstill.rocks) to see how to set up HTTPS with a reverse proxy, you still have time, the 20 minutes are not over yet.

You already did the hard part, the rest is easy(TM).

> **Bonus:** This website itself is hosted via Docker Swarm and build, deployed via [GitHub actions](https://github.com/ChristianUlbrich/dockerswarmstill.rocks/tree/master/.github/workflows), from a **single** [docker-compose.yml](https://github.com/ChristianUlbrich/dockerswarmstill.rocks/blob/master/docker-compose.yml) if you are a little bit impatient (and still managed to read until the very end!)

