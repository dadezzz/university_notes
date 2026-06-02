FROM docker.io/library/node:26.3.0-alpine@sha256:144769ec3f32e8ee36b3cfde91e82bee25d9367b20f31a151f3f7eea3a2a8541

RUN apk add --no-cache git

# renovate: datasource=npm depName=pnpm versioning=npm
ENV PNPM_VERSION="11.3.0"

RUN --mount=type=cache,sharing=locked,target=/root/.npm npm install -g "pnpm@$PNPM_VERSION"

ENV PNPM_HOME="/usr/local/pnpm"
ENV PATH="/usr/local/pnpm/bin:$PATH"

RUN pnpm config set store-dir /usr/local/pnpm/store
