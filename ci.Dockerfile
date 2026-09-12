FROM ghcr.io/typst/typst:0.15.1@sha256:032e292249bcd378480cc7c142cfa324b63ef8aadeb88d7e7230320c4c9c422f AS typst
FROM git.zarantonello.dev/infra/ci-pnpm:v1.1.4@sha256:7e49fb9a710190a935f7fb3f80e66b43c73b471120ed6a4d64d125ab1ce7f44a

COPY --from=typst /bin/typst /usr/bin/typst
