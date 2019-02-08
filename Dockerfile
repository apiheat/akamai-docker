FROM centos:7

ENV AKAMAI_CLI_HOME=/cli \
    PIP_NO_CACHE_DIR=off

RUN yum install epel-release --setopt=tsflags=nodocs -y -q && \
    yum install -y -q --setopt=tsflags=nodocs https://centos7.iuscommunity.org/ius-release.rpm && \
    yum install -y -q --setopt=tsflags=nodocs wget jq python36u python36u-pip && \
    yum clean all && rm -rf /var/cache/yum && \
    ln -s /usr/bin/python3.6 /usr/bin/python3 && ln -s /usr/bin/pip3.6 /usr/bin/pip3 && \
    pip3 install --no-cache-dir edgegrid-python && rm -rf /root/.cache/ && \
    wget --quiet -O /usr/local/bin/akamai https://github.com/akamai/cli/releases/download/1.0.2/akamai-1.0.2-linuxamd64 && \
    chmod +x /usr/local/bin/akamai && \
    echo '[ ! -z "$TERM" -a -r /etc/motd ] && cat /etc/motd' >> /root/.bashrc && \
    echo '### Welcome to Akamai CLI docker container (https://github.com/apiheat/akamai-docker) ###' > /etc/motd && \
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

RUN akamai install cps --force && \
    rm -rf /cli/.akamai-cli/src/cli-cps/.git && \
    akamai cps --version >> /etc/motd
RUN akamai install dns --force && \
    rm -rf /cli/.akamai-cli/src/cli-dns/.git && \
    akamai dns --version >> /etc/motd
RUN akamai install property --force && \
    rm -rf /cli/.akamai-cli/src/cli-property/.git && \
    echo "akamai property $(akamai property --version)" >> /etc/motd
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
RUN akamai install https://github.com/apiheat/akamai-cli-reporting --force && \
    rm -rf /cli/.akamai-cli/src/akamai-cli-reporting/.git && \
    akamai reporting --version >> /etc/motd
RUN akamai install https://github.com/apiheat/akamai-cli-diagnostic-tools --force && \
    rm -rf /cli/.akamai-cli/src/akamai-cli-diagnostic-tools/.git && \
    akamai diagnostic-tools --version >> /etc/motd

    # AppSec as Akamai installation is fucked
RUN yum install -y -q --setopt=tsflags=nodocs git && \
    git clone https://github.com/akamai/cli-appsec /cli/.akamai-cli/src/cli-appsec && \
    rm -rf /cli/.akamai-cli/src/cli-appsec/.git /cli/.akamai-cli/src/cli-appsec/bin/akamai-appsec && \
    wget --quiet -O /cli/.akamai-cli/src/cli-appsec/bin/akamai-appsec https://github.com/akamai/cli-appsec/releases/download/0.1.0/akamai-appsec-0.1.0-linux-amd64 && \
    chmod +x /cli/.akamai-cli/src/cli-appsec/bin/akamai-appsec && \
    yum remove -y -q git && yum autoremove -y && yum clean all && rm -rf /var/cache/yum && \
    echo "akamai appsec $(akamai appsec --version)" >> /etc/motd

ENV AKAMAI_CLI_HOME=/cli
VOLUME /cli
VOLUME /root/.edgerc
