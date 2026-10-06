FROM git.zarantonello.dev/university/notes-ci:v2026.10.04.1@sha256:8d607bda85fe0b70b783468b85e666176e368384f31b4d6476c0bbeee595b928 AS builder

WORKDIR /srv

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY patches ./patches
RUN --mount=type=cache,sharing=locked,target=/root/.local/share/pnpm/store pnpm install -P

COPY . ./
RUN pnpm run build

FROM docker.io/library/caddy:2.11.7-alpine@sha256:d76116d819d5162f464b0f2cd09bd28c568a86148c7bc539ce17c33eb22d8bbb

COPY Caddyfile /etc/caddy/Caddyfile
COPY --from=builder /srv/dist /srv
