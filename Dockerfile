FROM ghcr.io/stackexchange/dnscontrol:4.18.0@sha256:8fb45356a18f22f07dbdb20348ad453b9f705e1618118e3635dedde3bd2e809d

LABEL repository="https://github.com/Jniklas2/DNSControl-Action"
LABEL maintainer="Jniklas2 <github@sl.crcr.tech>"

LABEL "com.github.actions.name"="DNSControl"
LABEL "com.github.actions.description"="Deploy your DNS configuration to multiple providers."
LABEL "com.github.actions.icon"="cloud"
LABEL "com.github.actions.color"="yellow"

RUN apk -U --no-cache upgrade && \
    apk add --no-cache --upgrade bash ca-certificates curl grep libc6-compat && \
    update-ca-certificates

RUN ["dnscontrol", "version"]

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
