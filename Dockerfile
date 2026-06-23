FROM git.zarantonello.dev/university/notes:ci@sha256:5fe087acd37d126726c1b850030386c7e7496031c6541965fed0cb002c52c3b6 AS builder

WORKDIR /srv

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
RUN --mount=type=cache,sharing=locked,target=/root/.local/share/pnpm/store pnpm install -p

COPY . ./
RUN pnpm run build

FROM docker.io/library/caddy:2.11.4-alpine@sha256:c2af7d9004854180322ffd6f81b918874cee01f629084ab4d8ac0b96aa442432

COPY --from=builder /srv/dist /srv

ENTRYPOINT ["caddy", "file-server", "--root=/srv"]
