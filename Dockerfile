FROM git.zarantonello.dev/university/notes-ci:v2026.09.19.1@sha256:4d4cedbd3fac15ff65228b2cfbff81577a42166c561edf5573dee61cdd84e97e AS builder

WORKDIR /srv

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY patches ./patches
RUN --mount=type=cache,sharing=locked,target=/root/.local/share/pnpm/store pnpm install -P

COPY . ./
RUN pnpm run build

FROM docker.io/library/caddy:2.11.4-alpine@sha256:6aeddd44c3078b0f9a35206472a11420648a79c184603ef95957d0a20044cb2b

COPY Caddyfile /etc/caddy/Caddyfile
COPY --from=builder /srv/dist /srv
