# SwarmCLI Charts

[SwarmCLI Charts](https://github.com/Eldara-Tech/swarmcli-charts) is a Helm-inspired repository of reusable packages rendered for Docker Swarm. Current chart examples include Traefik, Whoami, GitLab, Keycloak, MariaDB, PostgreSQL, Redis, Renovate, Superset, SwarmCLI CD, Vaultwarden, and Zammad. The repository publishes a Helm-style `index.yaml` to GitHub Pages and attaches packaged charts and checksums to releases.

Add the repository once, then use its charts through `swarmcli`:

```bash
swarmcli charts repo add swarmcli-charts \
  https://eldara-tech.github.io/swarmcli-charts
swarmcli charts repo update
swarmcli charts search
swarmcli charts show chart swarmcli-charts/whoami
swarmcli charts show values swarmcli-charts/whoami
swarmcli charts template hello swarmcli-charts/whoami
swarmcli charts install hello swarmcli-charts/whoami \
  --set ingress.host=whoami.example.com
```

The `charts` commands are non-interactive and provide a Helm-like package workflow for Swarm. A chart can render a Compose-style stack, validate values, install or upgrade a release, show a diff, and retain revision history for rollback.

For GitOps-style declarative releases, keep chart versions and values in a committed release file and run:

```bash
swarmcli charts apply -f swarmcli-release.yaml --dry-run
swarmcli charts apply -f swarmcli-release.yaml
```

Chart releases are versioned independently. Pin the chart version in a `swarmcli-release.yaml` file so deployments are reproducible:

```yaml
repositories:
  - name: swarmcli-charts
    url: https://eldara-tech.github.io/swarmcli-charts

releases:
  - name: hello
    chart: swarmcli-charts/whoami
    version: "0.1.8"
```

The charts repository also provides a Renovate preset that can open updates when a pinned chart changes:

```json
{
  "extends": ["github>Eldara-Tech/swarmcli-charts"]
}
```

See the upstream [SwarmCLI chart documentation](https://github.com/Eldara-Tech/swarmcli/blob/main/charts/README.md) for the complete command reference, release-file format, compatibility checks, and rollback behavior. The [charts README](https://github.com/Eldara-Tech/swarmcli-charts) covers the available chart list, values, GitOps workflow, testing, and contribution instructions.