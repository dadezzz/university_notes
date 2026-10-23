FROM git.zarantonello.dev/university/notes-ci:v2026.10.19.1@sha256:9e564469f0c593c9516bfbdd0a68cb8099b20a8e1c5b8f3aa8f0ec011f1a6ef1 AS builder

WORKDIR /srv

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY patches ./patches
RUN --mount=type=cache,sharing=locked,target=/root/.local/share/pnpm/store pnpm install -P

COPY . ./
RUN pnpm run build

FROM docker.io/library/caddy:2.11.7-alpine@sha256:eb4d35b7452d1ab6171fbdbe8d9275b2301dad6dad92115d91e19fb9b24d510f

COPY Caddyfile /etc/caddy/Caddyfile
COPY --from=builder /srv/dist /srv
