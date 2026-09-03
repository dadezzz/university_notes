FROM ghcr.io/typst/typst:0.15.1@sha256:032e292249bcd378480cc7c142cfa324b63ef8aadeb88d7e7230320c4c9c422f AS typst
FROM git.zarantonello.dev/infra/ci-pnpm:v1.0.1@sha256:cc0fe239caf067d0270705aad16089a25383a9e76e0b98aa5966164c8cb19984

COPY --from=typst /bin/typst /usr/bin/typst
