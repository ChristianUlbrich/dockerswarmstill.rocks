# SwarmCLI CD

`swarmcli-cd` is a GitOps controller for Docker Swarm. It fetches an application definition from Git, renders charts or Compose-derived applications, plans the difference from the live Swarm, applies the desired state, and reports health and drift.

It is useful when you want:

- Git to be the source of truth for applications and release versions.
- Continuous drift detection instead of relying on the next CI deployment.
- Per-application and per-service sync and health status.
- Pruning of resources that leave the declared application set.
- Revision history and rollback, with Swarm update failure handling.
- Sync waves and app-of-apps workflows for ordered deployments.

The controller runs on a Swarm manager and uses the Docker API through the mounted socket. Its API should remain private: the example stack does not publish it, and access is protected by an admin token. Reach it from inside the cluster or through an SSH tunnel rather than exposing the controller directly to the public internet.

A basic bootstrap uses the SwarmCLI CD chart with an immutable Docker config plus secret. Create the application set from the upstream [example](https://github.com/Eldara-Tech/swarmcli-cd/blob/main/examples/applications.yaml), then create the required Docker objects and label a manager node for the controller's data:

```bash
docker config create swarmcli-cd-applications ./applications.yaml
printf '%s' "$(openssl rand -hex 32)" | \
  docker secret create swarmcli-cd-token -
docker node update --label-add swarmcli-cd-data=true <manager-node>
```

Register the chart repository and install the controller as the `cd` release:

```bash
swarmcli charts repo add swarmcli-charts \
  https://eldara-tech.github.io/swarmcli-charts
swarmcli charts repo update
swarmcli charts install cd swarmcli-charts/swarmcli-cd
```

The application set can instead come from a Git repository, so changing an application becomes a commit rather than a controller redeploy. The upstream [getting started guide](https://github.com/Eldara-Tech/swarmcli-cd/blob/main/docs/getting-started.md), [configuration reference](https://github.com/Eldara-Tech/swarmcli-cd/blob/main/docs/configuration.md), and [operations guide](https://github.com/Eldara-Tech/swarmcli-cd/blob/main/docs/operations.md) cover the production details.