# SwarmCLI RBAC proxy

Docker Swarm does not provide built-in per-user authorization for the Docker API. Anyone who can use an unrestricted Docker socket or TCP endpoint effectively has administrator access. `swarmcli-rbac-proxy` places an authorization layer between clients and the Docker daemon:

```text
Docker CLI or SwarmCLI -- mTLS --> swarmcli-rbac-proxy --> Docker daemon
                                      |-- client identity
                                      |-- role and binding checks
                                      `-- infrastructure protection
```

The proxy provides:

- Mutual TLS client authentication, with a distinct certificate for each user.
- Default-deny RBAC with built-in `viewer`, `operator`, and `admin` roles, plus custom roles.
- Protection for the proxy's own infrastructure stack and guarded `exec`/`attach` operations.
- An admin CLI named `swcproxy` for users, roles, bindings, and audit logs.
- SQLite by default, with PostgreSQL and in-memory storage options.

The bundled Swarm deployment uses Docker secrets for the server certificate, private key, client CA, and client CA key. Follow the upstream [getting started guide](https://github.com/Eldara-Tech/swarmcli-rbac-proxy/blob/main/docs/getting-started.md) to generate certificates and onboard users; do not copy example credentials into a production stack.

For the full configuration and permission model, see the proxy's [configuration reference](https://github.com/Eldara-Tech/swarmcli-rbac-proxy/blob/main/docs/configuration.md) and [roles and permissions guide](https://github.com/Eldara-Tech/swarmcli-rbac-proxy/blob/main/docs/rbac.md).