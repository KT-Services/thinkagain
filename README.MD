# thinkagain

This repository contains the Docker Compose stacks running on the "thinkagain" server.

Each service has its own directory containing its Docker Compose configuration and a dedicated Makefile. The root Makefile can manage all stacks at once.
The Usage of Makefile's was chosen for the ability to incorporate git cloning and pulling among the build steps of custom images such as the `overleaf-ce:ext` image.

## Stacks

Currently managed stacks:

* nginx-proxy-manager
* Authentik
* Outline
* Overleaf

Repository structure:

```text
.
├── Makefile
├── README.md
├── nginx/
│   ├── compose.yml
│   └── Makefile
├── authentik/
│   ├── compose.yml
│   └── Makefile
├── outline/
│   ├── compose.yml
│   └── Makefile
└── overleaf/
    ├── compose.yml
    └── Makefile
```

## Usage

All should be run from the root of the repository to manage the deployment.

### Start all stacks

```bash
make up
```

### Stop all stacks

```bash
make down
```

### Pull new images

```bash
make pull
```

Certain stacks will include git cloning / pulling and building in this step

### Update all stacks

```bash
make update
```

This runs the update target for every stacks, where each stack will most likely run the `pull` and `up` targets.

### Update and start everything

```bash
make all
```

This runs:

```text
update → up
```

## Managing individual stacks

Each stack can also be managed independently.

For example, to manage Outline:

```bash
make -C outline up
make -C outline down
make -C outline update
```

The same works for:

```bash
make -C nginx
make -C authentik
make -C overleaf
```

You can also run the default `all` target for a specific stack:

```bash
make outline
```

The same works for:

```bash
make authentik
make overleaf
```

## Deployment workflow

A typical deployment looks like this:

```bash
git clone # or git pull if already cloned 
make all
```

To update containers without stopping the entire server manually:

```bash
make update
make up
```

Each stack is managed independently, making it possible to deploy, update, or stop individual services without affecting the others.

## Adding a new stack

1. Create a directory for the new stack:

```text
new-service/
```

2. Add its Docker Compose file and Makefile:

```text
new-service/
├── compose.yml
└── Makefile
```

3. Add the stack name to the root Makefile:

```make
STACKS := authentik outline overleaf new-service
```

The new stack will then automatically be included in:

```bash
make up
make down
make update
make pull
make all
```