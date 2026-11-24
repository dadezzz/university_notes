FROM ghcr.io/typst/typst:0.15.1@sha256:032e292249bcd378480cc7c142cfa324b63ef8aadeb88d7e7230320c4c9c422f AS typst
FROM git.zarantonello.dev/infra/ci-pnpm:v2026.11.24.1@sha256:a0b6f90b5d57b45426b3cf851db5fdc13d30c733f986027d61e0dbbcbf789021

# renovate: datasource=github-tags depName=typstyle-rs/typstyle versioning=semver
ENV TYPSTYLE_VERSION="v0.15.3"

RUN curl -L https://github.com/typstyle-rs/typstyle/releases/download/$TYPSTYLE_VERSION/typstyle-x86_64-unknown-linux-musl -o /usr/local/bin/typstyle && \
    chmod +x /usr/local/bin/typstyle

COPY --from=typst /bin/typst /usr/bin/typst
