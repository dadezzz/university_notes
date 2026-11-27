FROM git.zarantonello.dev/university/notes-ci:v2026.11.26.1@sha256:9198a997bdb8248ea822774e89110b64ec18d45aaed11baf218e8e0aecd03b71 AS builder

WORKDIR /srv

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY patches ./patches
RUN --mount=type=cache,sharing=locked,target=/root/.local/share/pnpm/store pnpm install -P

COPY . ./
RUN pnpm run build

FROM docker.io/library/caddy:2.11.9-alpine@sha256:003a97808e781aa9f7e75cc2f43d34d461099031faf5e20faefb9f61126836f0

COPY Caddyfile /etc/caddy/Caddyfile
COPY --from=builder /srv/dist /srv
