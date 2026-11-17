FROM git.zarantonello.dev/university/notes-ci:v2026.11.16.2@sha256:ea7beb9495be6088e5b5ef37c8761d2771f12d2af21ce3a06ab32b2cfbf3a720 AS builder

WORKDIR /srv

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY patches ./patches
RUN --mount=type=cache,sharing=locked,target=/root/.local/share/pnpm/store pnpm install -P

COPY . ./
RUN pnpm run build

FROM docker.io/library/caddy:2.11.9-alpine@sha256:003a97808e781aa9f7e75cc2f43d34d461099031faf5e20faefb9f61126836f0

COPY Caddyfile /etc/caddy/Caddyfile
COPY --from=builder /srv/dist /srv
