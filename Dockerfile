FROM git.zarantonello.dev/university/notes-ci:v2026.09.03.1@sha256:8e31ad0df2542b572ed883a8cda78baacf71fd294a1d6201641b5195a798d636 AS builder

WORKDIR /srv

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
RUN --mount=type=cache,sharing=locked,target=/root/.local/share/pnpm/store pnpm install -p

COPY . ./
RUN pnpm run build

FROM docker.io/library/caddy:2.11.4-alpine@sha256:5f5c8640aae01df9654968d946d8f1a56c497f1dd5c5cda4cf95ab7c14d58648

COPY Caddyfile /etc/caddy/Caddyfile
COPY --from=builder /srv/dist /srv
