## Prerequisites

- Docker with the `proxy` external network already created, (for the forseeable future `cityplaza` too)
- Env file present at `../environments/nginx/.env` (see `.env.template` for what needs to be filled in)

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
cp ../environments/nginx/.env.template ../environments/nginx/.env
```

## Cloudflared Setup
If Cloudflared is needed, uncomment the following code block in `compose.yml`. to be able to expose through cloudflare tunnels

```yaml
services:
  cloudflared:
    image: cloudflare/cloudflared:latest
    container_name: cloudflared
    restart: unless-stopped
    command: tunnel --no-autoupdate run
    networks:
      - internal
    environment:
      - TUNNEL_TOKEN=${TUNNEL_TOKEN}
```

And fill in a `TUNNEL_TOKEN` in `../environments/nginx/.env`

Then Cloudflare's tunnel configuration can simply point everything at Nginx:
```yaml
ingress:
  - hostname: jellyfin.example.com
    service: http://nginx:80

  - hostname: auth.example.com
    service: http://nginx:80

  - hostname: overleaf.example.com
    service: http://nginx:80

  - service: http_status:404
```