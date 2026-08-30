## Prerequisites

- Docker with the `proxy` external network already created
- Authentik instance with an OAuth2/OIDC provider configured for outline
- Env file populated at `../environments/outline/.env` (see `.env.template` for what needs to be filled in)

## Usage

```bash
make up      # start all services (detached)
make down    # stop all services
make logs    # tail logs
make update  # pull latest overleaf-cep, rebuild images, pull latest mongo/redis/cloudflared
```

`make all` runs `update` then `up`.


## Environment

Copy `.env.template` to `../environments/overleaf/.env` and fill in all values.

```bash
cp .env.template ../environments/outline/.env
```

## Authentik setup

Create an OAuth2/OIDC provider in Authentik and an Application pointing at it. The redirect URI should be `<OUTLINE_SITE_URL>/auth/oidc.callback`. Copy the issuer URL, client ID, client secret, and endpoint URLs into the `OIDC_*` env vars.