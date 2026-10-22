FROM git.zarantonello.dev/university/notes-ci:v2026.10.19.1@sha256:9e564469f0c593c9516bfbdd0a68cb8099b20a8e1c5b8f3aa8f0ec011f1a6ef1 AS builder

WORKDIR /srv

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY patches ./patches
RUN --mount=type=cache,sharing=locked,target=/root/.local/share/pnpm/store pnpm install -P

COPY . ./
RUN pnpm run build

FROM docker.io/library/caddy:2.11.7-alpine@sha256:24ec7b05bc532c7bb57f727030c5056e257ff7138b4b50460306819ff79362bd

COPY Caddyfile /etc/caddy/Caddyfile
COPY --from=builder /srv/dist /srv
