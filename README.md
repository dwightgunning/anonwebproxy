# anonwebproxy

An anonymous web proxy Docker image that combines [Privoxy](https://www.privoxy.org/) and [Tor](https://www.torproject.org).

<https://hub.docker.com/r/dwightgunning/anonwebproxy>

The image is Alpine based, includes a health check and remains lightweight at ~10 MB. Tor and Privoxy are launched via runit.

## Running the image

- [Specify the init process](https://docs.docker.com/engine/reference/run/#specify-an-init-process) (`--init`)
- Bind the HTTP Proxy (8118) and Tor SOCKS5 (9050) ports for access from the host

```(sh)
docker run --init --rm -p 8118:8118 -p 9050:9050 dwightgunning/anonwebproxy:latest
```

## Development

### Linting

Linting with [Hadolint](https://github.com/hadolint/hadolint) from the command line.

```(sh)
hadolint Dockerfile
```

### Continuous Integration

The ci workflow can be run locally with [act](https://github.com/nektos/act).

```(sh)
act \
  --env-file .act/.env \
  --secret-file .act/.secrets \
  --workflows .github/workflows/ci.yml
```

## Copyright and license information

Copyright (c) 2023 Dwight Gunning. All rights reserved.

See the file "LICENSE" for information on the history of this software, terms & conditions for usage, and a DISCLAIMER OF ALL WARRANTIES.
