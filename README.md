# anonwebproxy

An anonymous web proxy.

## Running the image

```(sh)
docker run --init --rm -p 8118:8118 -p 9050:9050 dwightgunning/anonwebproxy:latest
```

## Development

### Linting

Linting with [Hadolint](https://github.com/hadolint/hadolint) from the command line.

```(sh)
hadolint Dockerfile
```

## Copyright and license information

Copyright (c) 2023 Dwight Gunning. All rights reserved.

See the file "LICENSE" for information on the history of this software, terms & conditions for usage, and a DISCLAIMER OF ALL WARRANTIES.
