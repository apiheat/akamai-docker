FROM amd64/alpine:latest

ENV AKAMAI_CLI_HOME=/cli

RUN apk add --no-cache --update openssl \
        ca-certificates \
        libc6-compat \
        libstdc++ \
        wget \
        jq \
        bash && \
        rm -rf /var/cache/apk/* && \
    wget --quiet -O /usr/local/bin/akamai https://github.com/akamai/cli/releases/download/1.1.3/akamai-1.1.3-linuxamd64 && \
    chmod +x /usr/local/bin/akamai && \
    echo '[ ! -z "$TERM" -a -r /etc/motd ] && cat /etc/motd' >> /root/.bashrc && \
    echo '### Welcome to Akamai CLI SL docker container (https://github.com/apiheat/akamai-docker) ###' > /etc/motd && \
    echo '### The following versions are installed ###' >> /etc/motd && \
    akamai --version >> /etc/motd

RUN mkdir -p /cli/.akamai-cli && \
    echo "[cli]" > /cli/.akamai-cli/config && \
    echo "cache-path            = /cli/.akamai-cli/cache" >> /cli/.akamai-cli/config && \
    echo "config-version        = 1" >> /cli/.akamai-cli/config && \
    echo "enable-cli-statistics = false" >> /cli/.akamai-cli/config && \
    echo "last-ping             = 2018-04-27T18:16:12Z" >> /cli/.akamai-cli/config && \
    echo "client-id             =" >> /cli/.akamai-cli/config && \
    echo "install-in-path       =" >> /cli/.akamai-cli/config && \
    echo "last-upgrade-check    = ignore" >> /cli/.akamai-cli/config

RUN akamai install purge --force && \
    rm -rf /cli/.akamai-cli/src/cli-purge/.git && \
    akamai purge --version >> /etc/motd
RUN akamai install https://github.com/apiheat/akamai-cli-a2 --force && \
    rm -rf /cli/.akamai-cli/src/akamai-cli-a2/.git && \
    akamai a2 --version >> /etc/motd
RUN akamai install https://github.com/apiheat/akamai-cli-cpcodes --force && \
    rm -rf /cli/.akamai-cli/src/akamai-cli-cpcodes/.git && \
    akamai cpcodes --version >> /etc/motd
RUN akamai install https://github.com/apiheat/akamai-cli-frn --force && \
    rm -rf /cli/.akamai-cli/src/akamai-cli-frn/.git && \
    akamai frn --version >> /etc/motd
RUN akamai install https://github.com/apiheat/akamai-cli-netlist --force && \
    rm -rf /cli/.akamai-cli/src/akamai-cli-netlist/.git && \
    akamai netlist --version >> /etc/motd
RUN akamai install https://github.com/apiheat/akamai-cli-netstorage --force && \
    rm -rf /cli/.akamai-cli/src/akamai-cli-netstorage/.git && \
    akamai netstorage --version >> /etc/motd
RUN akamai install https://github.com/apiheat/akamai-cli-overview --force && \
    rm -rf /cli/.akamai-cli/src/akamai-cli-overview/.git && \
    akamai overview --version >> /etc/motd
RUN akamai install https://github.com/apiheat/akamai-cli-siteshield --force && \
    rm -rf /cli/.akamai-cli/src/akamai-cli-siteshield/.git && \
    akamai siteshield --version >> /etc/motd
RUN akamai install https://github.com/apiheat/akamai-cli-users --force && \
    rm -rf /cli/.akamai-cli/src/akamai-cli-users/.git && \
    akamai users --version >> /etc/motd
RUN akamai install https://github.com/apiheat/akamai-cli-diagnostic-tools --force && \
    rm -rf /cli/.akamai-cli/src/akamai-cli-diagnostic-tools/.git && \
    akamai diagnostic-tools --version >> /etc/motd

ENV AKAMAI_CLI_HOME=/cli
VOLUME /cli
VOLUME /root/.edgerc

CMD ["/bin/bash"]
