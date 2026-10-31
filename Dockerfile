FROM git.zarantonello.dev/university/notes-ci:v2026.10.25.1@sha256:89949607ad570087fa34b4b4f571781e149dd12d62974776f379b25eca00616b AS builder

WORKDIR /srv

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY patches ./patches
RUN --mount=type=cache,sharing=locked,target=/root/.local/share/pnpm/store pnpm install -P

COPY . ./
RUN pnpm run build

FROM docker.io/library/caddy:2.11.7-alpine@sha256:e70b164da81ef698b3ad19af799ea6086ce6d9e48ed4079eb9fe26f6fbf14ee5

COPY Caddyfile /etc/caddy/Caddyfile
COPY --from=builder /srv/dist /srv
