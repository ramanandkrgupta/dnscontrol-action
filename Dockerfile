FROM alpine:3

LABEL repository="https://github.com/is-a-dev/dnscontrol-action"
LABEL maintainer="ellify.xyz <admin@ellify.xyz>"

LABEL "com.github.actions.name"="DNSControl Action"
LABEL "com.github.actions.description"="Deploy your DNS configuration using DNSControl."
LABEL "com.github.actions.icon"="cloud"
LABEL "com.github.actions.color"="blue"

ENV DNSCONTROL_VERSION="4.14.0"
ENV USER=dnscontrol-user

RUN apk -U --no-cache upgrade && \
    apk add --no-cache bash ca-certificates curl libc6-compat tar

RUN  addgroup -S dnscontrol-user && adduser -S dnscontrol-user -G dnscontrol-user --disabled-password

RUN curl -sL "https://github.com/StackExchange/dnscontrol/releases/download/v${DNSCONTROL_VERSION}/dnscontrol_${DNSCONTROL_VERSION}_linux_amd64.tar.gz" \
    -o dnscontrol && \
    tar xvf dnscontrol

RUN chown dnscontrol-user:dnscontrol-user  dnscontrol

RUN chmod +x dnscontrol && \
    chmod 755 dnscontrol && \
    cp dnscontrol /usr/local/bin/dnscontrol
    
RUN ["dnscontrol", "version"]

COPY entrypoint.sh bin/filter-preview-output.sh /
ENTRYPOINT ["/entrypoint.sh"]