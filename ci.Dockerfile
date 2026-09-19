FROM ghcr.io/typst/typst:0.15.1@sha256:032e292249bcd378480cc7c142cfa324b63ef8aadeb88d7e7230320c4c9c422f AS typst
FROM git.zarantonello.dev/infra/ci-pnpm:v1.1.8@sha256:e124501d6e8f1e75bb10e9c0e4198f220d37d02c860866ce07e21c87bc6bb886

# renovate: datasource=github-tags depName=typstyle-rs/typstyle versioning=semver
ENV TYPSTYLE_VERSION="v0.15.1"

RUN curl -L https://github.com/typstyle-rs/typstyle/releases/download/$TYPSTYLE_VERSION/typstyle-x86_64-unknown-linux-musl -o /usr/local/bin/typstyle && \
    chmod +x /usr/local/bin/typstyle

COPY --from=typst /bin/typst /usr/bin/typst
