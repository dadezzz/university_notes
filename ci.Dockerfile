FROM docker.io/library/node:26.2.0-alpine@sha256:7c6af15abe4e3de859690e7db171d0d711bf37d27528eddfe625b2fe89e097f8

RUN apk add --no-cache git

# renovate: datasource=npm depName=pnpm versioning=npm
ENV PNPM_VERSION="11.3.0"

RUN --mount=type=cache,sharing=locked,target=/root/.npm npm install -g "pnpm@$PNPM_VERSION"
