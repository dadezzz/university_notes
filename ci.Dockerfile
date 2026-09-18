FROM ghcr.io/typst/typst:0.15.1@sha256:032e292249bcd378480cc7c142cfa324b63ef8aadeb88d7e7230320c4c9c422f AS typst
FROM git.zarantonello.dev/infra/ci-pnpm:v1.1.7@sha256:35d75d27db7ed777a10cad500314c75e484b04f443b905e412079dd142f784b5

# renovate: datasource=github-tags depName=typstyle-rs/typstyle versioning=semver
ENV TYPSTYLE_VERSION="v0.15.1"

RUN curl -L https://github.com/typstyle-rs/typstyle/releases/download/$TYPSTYLE_VERSION/typstyle-x86_64-unknown-linux-musl -o /usr/local/bin/typstyle && \
    chmod +x /usr/local/bin/typstyle

COPY --from=typst /bin/typst /usr/bin/typst
