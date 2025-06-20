# WireGuard VPN with easy UI

## Intro
You can easily deploy a WireGuard VPN with [WireGuard Easy](https://github.com/wg-easy/wg-easy) on Docker Swarm. Duh! Cool, eh?

## How it works
WireGuard is a modern, high-performance VPN protocol that is designed to be simple and efficient. It uses state-of-the-art cryptography to secure connections between devices and first and foremost, is is easy to set up and use. The above project provides a user-friendly web interface for managing WireGuard connections, making it accessible even for those who are not familiar with VPN technologies and thus you can easily run your very own WireGuard VPN server on Docker Swarm.

This might be useful for securely accessing your home network, protecting your internet traffic on public Wi-Fi, or connecting remote devices securely or getting a _nice IP address for special purposes_.

/// note

While containers are isolated from each other in a Docker Swarm, it is still a potential attack vector, to compromise _another_ container and break isolation and thus get access to the connected VPN clients. So do use this with caution and make sure, that the UI is "properly" secured with HTTPS and a strong password.
///

## Preparation
* You need either a wildcard DNS entry, that points to the public IP of any of the Docker Swarm nodes, or a DNS entry, resolving to the public IP of any of the Docker Swarm nodes
```bash
nslookup wireguard.on.dockerswarmstill.rocks
```

We are _re-using_ the _global_ `admin-basic-auth@file` [BasicAuth middleware](https://doc.traefik.io/traefik/middlewares/http/basicauth/), that we configured in the [Traefik stack](../traefik/README.md) and thus you need to have the traefik _stack_ deployed already.

There is not much to configure, so you can simply download the `docker-compose.yml` file:

```bash
curl -L dockerswarmstill.rocks/stacks/wireguard/docker-compose.yml -o docker-compose.yml
```

* **Export** the `$DOMAIN_WIREGUARD`:
```bash
export DOMAIN_WIREGUARD=wireguard.on.dockerswarmstill.rocks
```

/// tip

Read the internal comments to learn what each configuration is for.

///

## Deploy it
* Connect to a manager node in your cluster (you might have only one node) and deploy it:

Deploy the stack with:

```bash
docker context use dockerswarmstillrocks
docker stack deploy -c docker-compose.yml wireguard
```
## Check it

* Check if the stack was deployed with:

```bash
docker stack ps wireguard
```

It will output something like:

```
ID             NAME                  IMAGE                        NODE                               DESIRED STATE   CURRENT STATE           ERROR     PORTS
w1z5bx0c4xkl   wireguard_wg-easy.1   ghcr.io/wg-easy/wg-easy:14   dockerswarmstillrocks-4gb-nbg1-1   Running         Running 6 seconds ago                       
```

* You can check the Traefik logs with:

```bash
docker service logs wireguard_wg-easy
```

## Check the user interface

After some seconds/minutes, Traefik will acquire the HTTPS certificates for the web user interface (UI).

You will be able to securely access the web UI at `https://$DOMAIN_WIREGUARD` (e.g. [https://wireguard.on.dockerswarmstill.rocks](https://wireguard.on.dockerswarmstill.rocks)) using the username `admin` and the created password (a pity `password-is-a-bad-password` does not work, isn't it?).

Now you can create your own WireGuard clients, download the configuration files and connect to your WireGuard VPN server with your favorite WireGuard client on $DOMAIN_WIREGUARD (e.g. wireguard.on.dockerswarmstill.rocks.

> **Tip:** Of course this assumes, that you do not have a firewall blocking the WireGuard port (51820/UDP) on your Docker Swarm nodes. If you do, make sure to open it.
