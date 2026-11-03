FROM git.zarantonello.dev/university/notes-ci:v2026.11.02.1@sha256:5e790592eb0bdb8dfd3f784dcfe93c3a6913b1089b95b55be6e6d80387ddd6be AS builder

WORKDIR /srv

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY patches ./patches
RUN --mount=type=cache,sharing=locked,target=/root/.local/share/pnpm/store pnpm install -P

COPY . ./
RUN pnpm run build

FROM docker.io/library/caddy:2.11.7-alpine@sha256:e70b164da81ef698b3ad19af799ea6086ce6d9e48ed4079eb9fe26f6fbf14ee5

COPY Caddyfile /etc/caddy/Caddyfile
COPY --from=builder /srv/dist /srv
