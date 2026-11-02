FROM ghcr.io/typst/typst:0.15.1@sha256:032e292249bcd378480cc7c142cfa324b63ef8aadeb88d7e7230320c4c9c422f AS typst
FROM git.zarantonello.dev/infra/ci-pnpm:v2026.10.31.1@sha256:e6e09a4058631c647b9c03b77b3e1877d251f809296f6b9252700d4d8ce108be

# renovate: datasource=github-tags depName=typstyle-rs/typstyle versioning=semver
ENV TYPSTYLE_VERSION="v0.15.2"

RUN curl -L https://github.com/typstyle-rs/typstyle/releases/download/$TYPSTYLE_VERSION/typstyle-x86_64-unknown-linux-musl -o /usr/local/bin/typstyle && \
    chmod +x /usr/local/bin/typstyle

COPY --from=typst /bin/typst /usr/bin/typst
