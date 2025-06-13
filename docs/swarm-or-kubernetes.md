# Docker Swarm Mode or Kubernetes

Docker Swarm is a robust and reliable product. Compared to Kubernetes it is way simpler to administer and it allows to keep the **same** old beloved `docker-compose.yml` (to some extent) for both _running_ Docker containers locally, as well as _deploying_ stacks.

Kubernetes is the de facto industry standard for massively, distributed computational work loads. However it entails a lot of learnings and buying managed Kubernetes is expensive compared to the simplicity of Docker Swarm.

Docker Swarm is not a silver bullet, you still have to solve the **same** problems, that are inherent to deploying container workloads - storage, security, access to registries, etc. **but** it is much easier to learn than Kubernetes and it is built on familiar Docker concepts. It is essentially a remotely controlled Docker engine, that "simply" distributes its running containers.

Investing in learning Docker Swarm, will allow you to lean the same concepts, that you can later apply if you are using Kubernetes, so I think it is something worth it.

## History

Docker, Inc., the company, created Docker Swarm Mode, it was integrated in Docker, it was the competition of Kubernetes.

At some point, Docker, Inc. decided to shift focus to Docker Desktop and other products. They sold all the Docker Swarm Mode side to Mirantis, Inc. that inherited the enterprise clients. And now [Docker Swarm Mode is a Mirantis product under their Kubernetes engine](https://www.mirantis.com/software/swarm/).

Mirantis has said, that [Docker Swarm is here to stay](https://www.mirantis.com/blog/swarm-is-here-to-stay-and-keeps-getting-better-in-security-and-ease-of-operations/) which to me sounds better than _"life-long support"_ 😁
