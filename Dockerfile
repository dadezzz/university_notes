FROM git.zarantonello.dev/university/notes-ci:v2026.10.13.1@sha256:89b414ce70a88c88fee951e1bc5d8ce8db6027cf9117399e4164d86819ec6da4 AS builder

WORKDIR /srv

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY patches ./patches
RUN --mount=type=cache,sharing=locked,target=/root/.local/share/pnpm/store pnpm install -P

COPY . ./
RUN pnpm run build

FROM docker.io/library/caddy:2.11.7-alpine@sha256:d8542f48d34a9cf4e4c11a478865229840e87e4c96ea3f439101f31a5d35f75f

COPY Caddyfile /etc/caddy/Caddyfile
COPY --from=builder /srv/dist /srv
