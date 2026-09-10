FROM ghcr.io/typst/typst:0.15.1@sha256:032e292249bcd378480cc7c142cfa324b63ef8aadeb88d7e7230320c4c9c422f AS typst
FROM git.zarantonello.dev/infra/ci-pnpm:v1.1.3@sha256:79ec9cc67899b315e8857eeab03880bb7ee8b79e2a4d865657da85c7e1155ff8

COPY --from=typst /bin/typst /usr/bin/typst
