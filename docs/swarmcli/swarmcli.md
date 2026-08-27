# SwarmCLI

SwarmCLI is a keyboard-driven terminal UI for Docker Swarm. It provides fast cluster visibility and management from the terminal. The feature set is available in the Community Edition unless marked as requiring a Business Edition license.

It works with the local Docker engine and remote engines configured through Docker contexts. A standalone binary is available for Linux, macOS, Windows, and FreeBSD releases, and the project also publishes container images and Homebrew installation support. See the upstream [installation guide](https://github.com/Eldara-Tech/swarmcli/blob/main/docs/installation.md) for the current release options.

<video autoplay loop muted playsinline class="rounded-xl border border-white/10 shadow-2xl w-full max-w-5xl mx-auto" poster="/img/swarmcli/hero-poster.png">
	<source src="/img/swarmcli/swarmcli-BI-MdrRH.webm" type="video/webm">
	<source src="/img/swarmcli/swarmcli-DXSlMsMb.mp4" type="video/mp4">
	<div class="bg-[#0c0c0c] p-12 text-center text-slate-500">Interactive Terminal Interface is loading...</div>
</video>

```bash
# Install on Linux to ~/.local/bin
curl -fsSL https://swarmcli.io/install.sh | sh -s -- ~/.local/bin

# Install with Homebrew on macOS or Linux
brew tap eldara-tech/tap
brew install swarmcli

# Use the current Docker context
swarmcli

# Check the installed version
swarmcli version
```

## Features

| Feature | What it provides | Availability |
| --- | --- | --- |
| Real-time observability | Live views of nodes, stacks, services, tasks, and containers | Community Edition |
| Stack awareness | Navigate a cluster hierarchically from stacks to services and tasks | Community Edition |
| Service logs | Follow logs for a service directly from the terminal UI | Community Edition |
| Secrets and configs | View, create, update, and rotate Docker secrets and configs | Community Edition |
| Secret reveal | Reveal secret values for debugging | Requires a Business Edition license |
| Service management | Scale, restart, remove, and update services with keyboard actions | Community Edition |
| Interactive shell | Open a shell in a running service task | Requires a Business Edition license |
| Volume management | View and manage Docker volumes | Requires a Business Edition license |
| Network management | Inspect and manage Docker networks | Community Edition |
| Chart package manager | Search repositories, render, install, upgrade, roll back, and diff chart releases with `swarmcli charts` | Community Edition |
| Declarative releases | Converge the Swarm to a committed release file with `swarmcli charts apply` | Community Edition |
| Docker contexts and SSH | Connect to the local engine or remote engines through Docker contexts and SSH | Community Edition |
| Lightweight deployment | Single static Go binary with no runtime dependencies | Community Edition |