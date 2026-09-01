FROM ghcr.io/typst/typst:0.15.1@sha256:032e292249bcd378480cc7c142cfa324b63ef8aadeb88d7e7230320c4c9c422f AS typst
FROM git.zarantonello.dev/infra/ci-pnpm:v1.0.0@sha256:d6119c2fbece2b90644fed77bae5065281ca460ac12d52b5e5909e0ac4519bf7

COPY --from=typst /bin/typst /usr/bin/typst
