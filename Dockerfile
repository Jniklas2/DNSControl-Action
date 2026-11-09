FROM ghcr.io/dnscontrol/dnscontrol:5.8.0@sha256:3f2f34eabd12559ecf4a02a9eed5d4b9e62876779bb8b109a2f8abff5d89a35c

LABEL repository="https://github.com/Jniklas2/DNSControl-Action"
LABEL maintainer="Jniklas2 <github@sl.crcr.tech>"

LABEL "com.github.actions.name"="DNSControl"
LABEL "com.github.actions.description"="Deploy your DNS configuration to multiple providers."
LABEL "com.github.actions.icon"="cloud"
LABEL "com.github.actions.color"="green"

RUN apk -U --no-cache upgrade && \
    apk add --no-cache --upgrade bash ca-certificates curl grep libc6-compat && \
    update-ca-certificates

RUN ["dnscontrol", "version"]

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
