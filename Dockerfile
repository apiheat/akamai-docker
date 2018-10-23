FROM centos:7

ENV AKAMAI_CLI_HOME=/cli
RUN yum install epel-release -y -q && \
    yum install -y -q wget jq && \
    yum clean all && rm -rf /var/cache/yum && \
    wget --quiet -O /usr/local/bin/akamai https://github.com/akamai/cli/releases/download/1.0.2/akamai-1.0.2-linuxamd64 && \
    chmod +x /usr/local/bin/akamai

RUN mkdir -p /cli/.akamai-cli && \
    echo "[cli]" > /cli/.akamai-cli/config && \
    echo "cache-path            = /cli/.akamai-cli/cache" >> /cli/.akamai-cli/config && \
    echo "config-version        = 1" >> /cli/.akamai-cli/config && \
    echo "enable-cli-statistics = false" >> /cli/.akamai-cli/config && \
    echo "last-ping             = 2018-04-27T18:16:12Z" >> /cli/.akamai-cli/config && \
    echo "client-id             =" >> /cli/.akamai-cli/config && \
    echo "install-in-path       =" >> /cli/.akamai-cli/config && \
    echo "last-upgrade-check    = ignore" >> /cli/.akamai-cli/config

RUN akamai install property --force && \
    akamai install purge --force && \
    akamai install https://github.com/apiheat/akamai-cli-a2 --force && \
    akamai install https://github.com/apiheat/akamai-cli-cpcodes --force && \
    akamai install https://github.com/apiheat/akamai-cli-frn --force && \
    akamai install https://github.com/apiheat/akamai-cli-netlist --force && \
    akamai install https://github.com/apiheat/akamai-cli-overview --force && \
    akamai install https://github.com/apiheat/akamai-cli-siteshield --force && \
    akamai install https://github.com/apiheat/akamai-cli-users --force && \
    akamai install https://github.com/apiheat/akamai-cli-reporting --force

ENV AKAMAI_CLI_HOME=/cli
VOLUME /cli
VOLUME /root/.edgerc