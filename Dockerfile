FROM git.zarantonello.dev/university/notes-ci:v2026.10.25.1@sha256:89949607ad570087fa34b4b4f571781e149dd12d62974776f379b25eca00616b AS builder

WORKDIR /srv

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY patches ./patches
RUN --mount=type=cache,sharing=locked,target=/root/.local/share/pnpm/store pnpm install -P

COPY . ./
RUN pnpm run build

FROM docker.io/library/caddy:2.11.7-alpine@sha256:eb4d35b7452d1ab6171fbdbe8d9275b2301dad6dad92115d91e19fb9b24d510f

COPY Caddyfile /etc/caddy/Caddyfile
COPY --from=builder /srv/dist /srv
