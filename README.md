# anonwebproxy

An anonymous web proxy Docker image that combines [Privoxy](https://www.privoxy.org/) and [Tor](https://www.torproject.org).

<https://hub.docker.com/r/dwightgunning/anonwebproxy>

The image is Alpine based and includes a health check. Tor and Privoxy are launched via runit.

## Running the image

The image serves an HTTP proxy (Privoxy, port 8118) and a SOCKS5 proxy (Tor, port 9050). Neither port asks for credentials, so run the image where only your own clients can reach it.

- [Specify the init process](https://docs.docker.com/engine/reference/run/#specify-an-init-process) (`--init`)
- Publish the ports on `127.0.0.1` only, for access from the host:

```(sh)
docker run --init --rm -p 127.0.0.1:8118:8118 -p 127.0.0.1:9050:9050 dwightgunning/anonwebproxy:latest
```

- Or publish no ports, and reach the image from containers on a private Docker network:

```(sh)
docker network create anonwebproxy
docker run --init -d --name anonwebproxy --network anonwebproxy dwightgunning/anonwebproxy:latest
```

Containers on that network can use `http://anonwebproxy:8118` or `socks5h://anonwebproxy:9050`.

### Who can connect

Both proxies accept clients from loopback and from the private ranges `10.0.0.0/8`, `172.16.0.0/12` and `192.168.0.0/16`, which include Docker's default networks. They refuse clients with any other address.

That keeps out clients with public addresses, but any client with a private address gets in. Most home and office LANs, VPNs and cloud VPCs use these same ranges. So if the ports are published on every interface, or the container uses the host's network, the rest of your LAN or VPC can use the image as an open proxy. On Docker Desktop, and wherever Docker's userland proxy forwards a published port, even a client with a public address reaches the container from a private one. Publishing on `127.0.0.1` is what restricts access. The rules are only a fallback.

If your clients use addresses outside these ranges, such as a Docker address pool or Tailscale address in `100.64.0.0/10`, the proxies refuse them. The healthcheck still passes, because it connects from `127.0.0.1`. To allow those clients, add their range as a `permit-access` line in `services/privoxy/config` and as a `SocksPolicy accept` line in `services/tor/torrc`, before its final `SocksPolicy reject *`.

### Using the SOCKS port

Connect with `socks5h://`, not `socks5://`. With `socks5h://` the client sends the hostname to Tor, which resolves it over the Tor network. With `socks5://` the client resolves the hostname itself, so your DNS server sees every site you visit.

```(sh)
curl --proxy socks5h://127.0.0.1:9050 https://check.torproject.org/api/ip
```

The HTTP proxy on port 8118 already passes hostnames to Tor.

### What "anonymous" covers

Traffic leaves through Tor, so the sites you visit see a Tor exit's address instead of yours.

That is all the image hides. Privoxy loads no action or filter files, so it forwards requests unchanged. Headers such as `User-Agent`, cookies, and anything else your client sends reach the site as sent. The Tor exit can also read any traffic that isn't encrypted with HTTPS.

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
