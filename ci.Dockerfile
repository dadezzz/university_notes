FROM ghcr.io/typst/typst:0.15.1@sha256:032e292249bcd378480cc7c142cfa324b63ef8aadeb88d7e7230320c4c9c422f AS typst
FROM git.zarantonello.dev/infra/ci-pnpm:v1.1.21@sha256:fbc515a4a572b7d74871c861f90105ff2e35f3fc1fcd673735df97b8fae48c8b

# renovate: datasource=github-tags depName=typstyle-rs/typstyle versioning=semver
ENV TYPSTYLE_VERSION="v0.15.2"

RUN curl -L https://github.com/typstyle-rs/typstyle/releases/download/$TYPSTYLE_VERSION/typstyle-x86_64-unknown-linux-musl -o /usr/local/bin/typstyle && \
    chmod +x /usr/local/bin/typstyle

COPY --from=typst /bin/typst /usr/bin/typst
