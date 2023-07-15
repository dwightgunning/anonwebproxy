FROM alpine:3.18.2
LABEL maintainer="dwightgunning"

RUN apk add --no-cache \
  tor=0.4.7.13-r2 \
  privoxy=3.0.34-r2 \
  runit=2.1.2-r7 \
  curl=8.1.2-r0

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
