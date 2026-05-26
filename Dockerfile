FROM git.zarantonello.dev/infra/ci:v3.1.1@sha256:bed84d93be3c16150c71aab07849ac5bdc9626885b36ed612cd4b746c2965aab AS builder

WORKDIR /srv

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
RUN --mount=type=cache,sharing=locked,target=/root/.local/share/pnpm/store pnpm install -p

COPY . ./
RUN pnpm run build

FROM docker.io/library/caddy:2.11.3-alpine@sha256:86deaf5e3d3408a6ccec08fbb79989783dd26e206ae10bcf78a801dc8c9ab794

COPY --from=builder /srv/dist /srv

ENTRYPOINT ["caddy", "file-server", "--root=/srv"]
