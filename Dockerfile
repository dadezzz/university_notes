FROM git.zarantonello.dev/university/notes-ci:v2026.11.08.1@sha256:f349e805ad7e7e0f8f7b0585a066c5927485156d6494a943ff3a2c39596d9108 AS builder

WORKDIR /srv

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY patches ./patches
RUN --mount=type=cache,sharing=locked,target=/root/.local/share/pnpm/store pnpm install -P

COPY . ./
RUN pnpm run build

FROM docker.io/library/caddy:2.11.9-alpine@sha256:003a97808e781aa9f7e75cc2f43d34d461099031faf5e20faefb9f61126836f0

COPY Caddyfile /etc/caddy/Caddyfile
COPY --from=builder /srv/dist /srv
