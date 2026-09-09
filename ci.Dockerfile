FROM ghcr.io/typst/typst:0.15.1@sha256:032e292249bcd378480cc7c142cfa324b63ef8aadeb88d7e7230320c4c9c422f AS typst
FROM git.zarantonello.dev/infra/ci-pnpm:v1.1.2@sha256:c983897318782b8c272bbefee3701268cceda980a7c0d0c38c801f575a014a44

COPY --from=typst /bin/typst /usr/bin/typst
