# Overleaf (Extended Community Edition)

Makefile-driven deployment of [overleaf-cep](https://github.com/yu-i-i/overleaf-cep), a community-maintained fork of Overleaf that adds OIDC/SSO support to the free Community Edition. Authentication is handled by Authentik via OIDC and native Overleaf login is disabled.

## Stack

| Service | Image | Role |
|---|---|---|
| `overleaf` | `sharelatex/sharelatex:ext-ce` | LaTeX editor |
| `mongo` | `mongo:latest` | Document store (replica set) |
| `redis` | `redis:latest` | Session / queue |
| `cloudflared` | `cloudflare/cloudflared` | Tunnel to public internet |

Sandboxed compiles run as sibling Docker containers using `texlive/texlive:latest-full`. The Docker socket is mounted read-only for this purpose.

## Prerequisites

- Docker with the `proxy` external network already created
- Authentik instance with an OAuth2/OIDC provider configured for Overleaf
- Env file populated at `../environments/overleaf/.env` (see `.env.template` for what needs to be filled in)
- The `overleaf-cep` image built locally (see [Build](#build))

## Build

The extended CE image is built from source via the [overleaf-cep](https://github.com/yu-i-i/overleaf-cep) repo.

```bash
make build   # clones repo if folder not yet exists, builds base + community images
```

Individual steps:

```bash
make clone         # clone overleaf-cep (skips if already present)
make pull          # update the repo
make build-base    # build the base image
make build-community  # build the community image
```

## Usage

```bash
make up      # start all services (detached)
make down    # stop all services
make logs    # tail logs
make update  # pull latest overleaf-cep, rebuild images, pull latest mongo/redis/cloudflared
```

`make all` runs `update` then `up`.

## Environment

Copy `.env.template` to ../environments/overleaf/.env` and fill in all values.

```bash
cp .env.template ../environments/overleaf/.env
```

| Variable | Description |
|---|---|
| `CLOUDFLARE_TUNNEL_TOKEN` | Cloudflare tunnel token |
| `OVERLEAF_APP_NAME` | Display name |
| `OVERLEAF_SITE_URL` | Public URL |
| `OVERLEAF_NAV_TITLE` | Browser/nav title |
| `SMTP_*` | Outbound mail settings |
| `ADMIN_EMAIL` | Admin address for notifications |
| `OVERLEAF_INVITE_TOKEN_SECRET` | Secret for invite tokens |
| `EXTERNAL_AUTH` | Auth driver (set to `oidc`) |
| `OIDC_*` | Authentik OIDC provider settings |

## Authentik setup

Create an OAuth2/OIDC provider in Authentik and an Application pointing at it. The redirect URI should be `<OVERLEAF_SITE_URL>/oidc/login/callback`. Copy the issuer URL, client ID, client secret, and endpoint URLs into the `OIDC_*` env vars.

User details (name, email) are synced from the OIDC token on every login (`OVERLEAF_OIDC_UPDATE_USER_DETAILS_ON_LOGIN=true`). The `sub` claim is used as the stable user identifier.

## mongo setup

on first boot the mongo database needs to be initialized with the command.

```bash

docker exec -it overleaf-mongo \
  mongosh --eval 'rs.initiate({
    _id: "overleaf",
    members: [{ _id: 0, host: "overleaf-mongo:27017" }]
  })'
```