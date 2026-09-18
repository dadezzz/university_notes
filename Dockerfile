FROM git.zarantonello.dev/university/notes-ci:v2026.09.17.2@sha256:1f428f6926ebc2936f516e46db7e4fe101f88546286b3d4cd2e4ab65e43bc246 AS builder

WORKDIR /srv

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY patches ./patches
RUN --mount=type=cache,sharing=locked,target=/root/.local/share/pnpm/store pnpm install -P

COPY . ./
RUN pnpm run build

FROM docker.io/library/caddy:2.11.4-alpine@sha256:de23def33b17fb5d1290b0f6c2add1d70780e52341896c00a4c8a2a2fe9d355e

COPY Caddyfile /etc/caddy/Caddyfile
COPY --from=builder /srv/dist /srv
