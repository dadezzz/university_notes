FROM git.zarantonello.dev/university/notes-ci:v2026.10.18.1@sha256:8507ee1571b234560ab4bd14296ab195bcd8e6892ab08dd8ff7c34a523b204a1 AS builder

WORKDIR /srv

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY patches ./patches
RUN --mount=type=cache,sharing=locked,target=/root/.local/share/pnpm/store pnpm install -P

COPY . ./
RUN pnpm run build

FROM docker.io/library/caddy:2.11.7-alpine@sha256:d8542f48d34a9cf4e4c11a478865229840e87e4c96ea3f439101f31a5d35f75f

COPY Caddyfile /etc/caddy/Caddyfile
COPY --from=builder /srv/dist /srv
