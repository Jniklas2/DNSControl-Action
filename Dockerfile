FROM ghcr.io/stackexchange/dnscontrol:4.27.1@sha256:cc719a3434d61bfcffc24ed93154cd9682c8f4861a47385a073aaf0ac83aad2e

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
