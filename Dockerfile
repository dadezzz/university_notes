FROM git.zarantonello.dev/university/notes-ci:v2026.10.03.1@sha256:7cd707095bc117c60ee6898e2ac3cac2f528c1c3c561473f93f411287c7b1ecb AS builder

WORKDIR /srv

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY patches ./patches
RUN --mount=type=cache,sharing=locked,target=/root/.local/share/pnpm/store pnpm install -P

COPY . ./
RUN pnpm run build

FROM docker.io/library/caddy:2.11.6-alpine@sha256:c776e0c6413b544d0459665e54ec7b8b2a15000c0cbee8b254da0067b1d184ff

COPY Caddyfile /etc/caddy/Caddyfile
COPY --from=builder /srv/dist /srv
