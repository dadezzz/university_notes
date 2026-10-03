FROM git.zarantonello.dev/university/notes-ci:v2026.09.30.1@sha256:8ce55f919250d8ae5f5e36c946e5032151715601f220cdc21c3291ad95551e3f AS builder

WORKDIR /srv

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY patches ./patches
RUN --mount=type=cache,sharing=locked,target=/root/.local/share/pnpm/store pnpm install -P

COPY . ./
RUN pnpm run build

FROM docker.io/library/caddy:2.11.6-alpine@sha256:c776e0c6413b544d0459665e54ec7b8b2a15000c0cbee8b254da0067b1d184ff

COPY Caddyfile /etc/caddy/Caddyfile
COPY --from=builder /srv/dist /srv
