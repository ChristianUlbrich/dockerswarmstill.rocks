# Traefik Reverse Proxy with HTTPS

## Intro

So, you have a **Docker Swarm mode** cluster set up as described in [Docker Swarm still rocks](https://dockerswarmstill.rocks)?

With [Traefik](https://traefik.io/traefik/) you can add a versatile _Load balancer_ and _reverse proxy_ with _HTTPS_, that can do a lot of things:

* Handle **connections**.
* **Expose** specific services and applications based on their domain names.
* Handle **multiple domains** (if you need to). Similar to "virtual hosts".
* Handle **HTTPS**.
* Acquire (generate) **HTTPS certificates automatically** (including renewals) with [Let's Encrypt](https://letsencrypt.org/).
* Add HTTP **Basic Auth** for any service that you need to protect and doesn't have its own security, etc.
* Get all its configurations automatically from **Docker labels** set in your stacks (you don't need to update configuration files).

These ideas, techniques, and tools would also apply to other cluster orchestrators, like Kubernetes or Mesos, to add a main load balancer with HTTPS support, certificate generation, etc. But this article is focused on Docker Swarm mode. Traefik itself can be used as an ingress controller for Kubernetes, so you can apply the same ideas there similarly.

### User Interface

The guide includes how to expose the internal Traefik web UI dashboard through the same Traefik load balancer, using a secure HTTPS certificate and HTTP Basic Auth.

<img src="https://dockerswarm.rocks/img/traefik-screenshot.webp">

## How it works

The idea is to have a main load balancer/reverse proxy that covers all the Docker Swarm cluster and handles HTTPS certificates and requests for each domain.

But doing it in a way that allows you to have other Traefik services inside each stack without interfering with each other, to redirect based on path in the same stack (e.g. one container handles `/` for a web frontend and another handles `/api` for an API under the same domain), or to redirect from HTTP to HTTPS selectively.

Each stack dynamically configures Traefik, so that it can be deployed completely separated from the original (initial) Traefik stack.

/// note

The setup we propose here, does not properly isolate stacks from each other, because **each** stack can **arbitrarily** configure **any** routes, i.e. one stack could "steal" the route from another. Security-wise we assume, that all stacks are _"friendly"_. Because _deploying a stack_ involves full remote control over the cluster anyway, this is a viable approach. For separating stacks you will want to use more advanced concepts (e.g. multiple Docker Swarm clusters, nested Kubernetes, Kubernetes with RBAC). 

///

## Concept
Without going into too much into detail(TM), this can be done by an [overlay network](https://docs.docker.com/engine/network/drivers/overlay/) in Docker Swarm that all nodes in the cluster are sharing and via the usage of the [Traefik Docker provider](https://doc.traefik.io/traefik/providers/docker/), allowing for configuring Traefik via Docker Labels, that can be associated in a stack deployment file.

For any generic routing needs, the [Traefik file provider](https://doc.traefik.io/traefik/providers/file/) is also used. 

## Preparation
* You need either a wildcard DNS entry, that points to the public IP of any of the Docker Swarm nodes, or a DNS entry, resolving to the public IP of any of the Docker Swarm nodes
```bash
nslookup traefik.on.dockerswarmstill.rocks
nslookup whoami.on.dockerswarmstill.rocks
```
* Connect to a manager node in your cluster (you might have only one node)
* Create a network that will be shared with Traefik and the containers that should be accessible from the outside, with:

```bash
docker context use dockerswarstillrocks
docker network create --driver=overlay traefik-public
```

* Create a password for a very (HTTP) basic auth, that can be used to secure the Traefik Dashboard
* Use `openssl` to generate the "hashed" version of `password-is-a-bad-password` and store it in an environment variable:

```bash
export ADMIN_HASHED_PASSWORD=$(openssl passwd -apr1 password-is-a-bad-password)
```

* Export a email address that will be used to register the HTTPS certificates with Let's Encrypt:
 
```bash
export DOMAIN_EMAIL=admin@example.org
```
> **Tip:** Please use a valid email address, as Let's Encrypt will send you important information about your certificates to that email address.

* and now configure Traefik appropriately, its config consists of a `services.yml`, a `traefik.yml` and a `docker-compose.yml`
* You can download templates:
```bash
curl -L dockerswarmstill.rocks/stacks/traefik/services.yml -o services.yml
curl -L dockerswarmstill.rocks/stacks/traefik/traefik.yml -o traefik.yml
curl -L dockerswarmstill.rocks/stacks/traefik/docker-compose.yml -o docker-compose.yml
```

* **Configure** Traefik itself and either replace `$DOMAIN_EMAIL` with the email address you exported above:
```YAML
{!./docs/stacks/traefik/traefik.yml!}
```
or stamp it into it with:
```bash
docker context use desktop-linux
docker compose run --rm envsubst
```

> **Tip:** Your "local" Docker context might have a different name.

* **Configure** the file provider with its global middleware and the dashboard, either replace `$HASHED_PASSWORD` with the password you generated above and replace `$DOMAIN_TRAEFIK_DASHBOARD` with the domain you want to use for the Traefik _Dashboard_ (e.g. `traefik.on.dockerswarmstill.rocks`):
```YAML
{!./docs/stacks/traefik/services.yml!}
```
or stamp it (_locally_) into it with:
```bash
docker compose run --rm envsubst
```

* and _finally_ **configure** the Traefik stack itself, either replace `$DOMAIN_WHOAMI` with the domain you want to use for the whoami _service_ (e.g. `whoami.on.dockerswarmstill.rocks`) or export it as an environment variable:

```YAML
{!./docs/stacks/traefik/docker-compose.yml!}
```

/// tip

Read the internal comments to learn what each configuration is for.

The file without comments is actually quite smaller, but the comments should give you an idea of what everything is doing.

///

## Deploy it

Deploy the stack with:

```bash
docker context use dockerswarstillrocks
docker stack deploy -c docker-compose.yml traefik
```
> **Tip:** Make sure, you are controlling your Docker Swarm manager.

## Check it

* Check if the stack was deployed with:

```bash
docker stack ps traefik
```

It will output something like:

```
ID             NAME                      IMAGE                   NODE                               DESIRED STATE   CURRENT STATE            ERROR     PORTS
jq7anezva94o   traefik_reverse-proxy.1   traefik:v2.4            dockerswarmstillrocks-4gb-nbg1-1   Running         Running 31 minutes ago             
zm4oaujqcvn7   traefik_whoami.1          traefik/whoami:latest   dockerswarmstillrocks-4gb-nbg1-1   Running         Running 31 minutes ago             
```

* You can check the Traefik logs with:

```bash
docker service logs traefik_reverse-proxy
```

## Check the user interface

After some seconds/minutes, Traefik will acquire the HTTPS certificates for the web user interface (UI).

You will be able to securely access the web UI at `https://traefik.<your domain>` using the created username and password.

Once you deploy a stack, you will be able to see it there and see how the different hosts and paths map to different Docker services / containers.

## Getting the client IP

If you need to read the client IP in your applications/stacks using the `X-Forwarded-For` or `X-Real-IP` headers provided by Traefik, you need to make Traefik listen directly, not through Docker Swarm mode, even while being deployed with Docker Swarm mode.

For that, you need to publish the ports using "host" mode.

So, the Docker Compose lines:

```YAML
    ports:
      - 80:80
      - 443:443
```

need to be:

```YAML
    ports:
      - target: 80
        published: 80
        mode: host
      - target: 443
        published: 443
        mode: host
```
