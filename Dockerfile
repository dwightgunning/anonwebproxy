FROM alpine:3.24.4@sha256:f59abe656b692d901e184be3445e084786602108599d2a51d229c0f5a48c71bf
LABEL maintainer="dwightgunning"

# The base image pins the Alpine release branch, which only ships security
# and bug fixes. Pinning exact package versions as well breaks the build
# whenever Alpine replaces one with a patched release.
# hadolint ignore=DL3018
RUN apk add --no-cache \
  tor \
  privoxy \
  runit \
  curl

COPY --link ./services/tor/torrc /etc/tor/torrc
COPY --link ./services/privoxy/config /etc/privoxy/config
COPY --link ./services/tor/run /etc/service/tor/run
COPY --link ./services/privoxy/run /etc/service/privoxy/run
COPY --link ./healthcheck.sh /usr/local/bin/healthcheck.sh

RUN addgroup -S anonwebproxy \
  && adduser -S anonwebproxy -G anonwebproxy \
  && chown -R anonwebproxy:anonwebproxy /etc/tor \
  && chown -R anonwebproxy:anonwebproxy /etc/privoxy \
  && chown -R anonwebproxy:anonwebproxy /etc/service \
  && chown -R anonwebproxy:anonwebproxy /usr/local/bin/healthcheck.sh

USER anonwebproxy

EXPOSE 8118 9050

HEALTHCHECK --interval=60s --timeout=10s --start-period=30s --retries=3 \
  CMD /usr/local/bin/healthcheck.sh

CMD ["runsvdir", "/etc/service"]
