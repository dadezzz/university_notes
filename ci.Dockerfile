FROM ghcr.io/typst/typst:0.15.1@sha256:032e292249bcd378480cc7c142cfa324b63ef8aadeb88d7e7230320c4c9c422f AS typst
FROM git.zarantonello.dev/infra/ci-pnpm:v1.1.5@sha256:d4011284a8cc8c627f8a3f94b8381b0ffaf1caff744c3ce5c9b64075553224ba

COPY --from=typst /bin/typst /usr/bin/typst
