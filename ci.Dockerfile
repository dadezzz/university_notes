FROM ghcr.io/typst/typst:0.15.1@sha256:032e292249bcd378480cc7c142cfa324b63ef8aadeb88d7e7230320c4c9c422f AS typst
FROM git.zarantonello.dev/infra/ci-pnpm:v1.1.1@sha256:ed87e9364a5448217835ebf4103ef275f15b0267a9580dec3ac716c1abaa0a26

COPY --from=typst /bin/typst /usr/bin/typst
