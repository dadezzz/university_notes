FROM git.zarantonello.dev/university/notes-ci:v2026.11.08.1@sha256:f349e805ad7e7e0f8f7b0585a066c5927485156d6494a943ff3a2c39596d9108 AS builder

WORKDIR /srv

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY patches ./patches
RUN --mount=type=cache,sharing=locked,target=/root/.local/share/pnpm/store pnpm install -P

COPY . ./
RUN pnpm run build

FROM docker.io/library/caddy:2.11.9-alpine@sha256:0bbb055bda6793c999bde78b1b5ce3e89f829fb031af2cf50056ea1246559fee

COPY Caddyfile /etc/caddy/Caddyfile
COPY --from=builder /srv/dist /srv
