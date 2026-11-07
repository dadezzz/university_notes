FROM git.zarantonello.dev/university/notes-ci:v2026.11.02.1@sha256:5e790592eb0bdb8dfd3f784dcfe93c3a6913b1089b95b55be6e6d80387ddd6be AS builder

WORKDIR /srv

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY patches ./patches
RUN --mount=type=cache,sharing=locked,target=/root/.local/share/pnpm/store pnpm install -P

COPY . ./
RUN pnpm run build

FROM docker.io/library/caddy:2.11.9-alpine@sha256:0bbb055bda6793c999bde78b1b5ce3e89f829fb031af2cf50056ea1246559fee

COPY Caddyfile /etc/caddy/Caddyfile
COPY --from=builder /srv/dist /srv
