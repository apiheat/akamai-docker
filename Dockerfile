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

RUN akamai install cps --force && \
    akamai install property --force && \
    akamai install purge --force && \
    akamai install https://github.com/apiheat/akamai-cli-a2 --force && \
    akamai install https://github.com/apiheat/akamai-cli-cpcodes --force && \
    akamai install https://github.com/apiheat/akamai-cli-frn --force && \
    akamai install https://github.com/apiheat/akamai-cli-netlist --force && \
    akamai install https://github.com/apiheat/akamai-cli-overview --force && \
    akamai install https://github.com/apiheat/akamai-cli-siteshield --force && \
    akamai install https://github.com/apiheat/akamai-cli-users --force && \
    akamai install https://github.com/apiheat/akamai-cli-reporting --force && \
    rm -rf /cli/.akamai-cli/src/akamai-cli-a2/.git && \
    rm -rf /cli/.akamai-cli/src/akamai-cli-cpcodes/.git && \
    rm -rf /cli/.akamai-cli/src/akamai-cli-frn/.git && \
    rm -rf /cli/.akamai-cli/src/akamai-cli-netlist/.git && \
    rm -rf /cli/.akamai-cli/src/akamai-cli-overview/.git && \
    rm -rf /cli/.akamai-cli/src/akamai-cli-reporting/.git && \
    rm -rf /cli/.akamai-cli/src/akamai-cli-siteshield/.git && \
    rm -rf /cli/.akamai-cli/src/akamai-cli-users/.git && \
    rm -rf /cli/.akamai-cli/src/cli-cps/.git && \
    rm -rf /cli/.akamai-cli/src/cli-property/.git && \
    rm -rf /cli/.akamai-cli/src/cli-purge/.git

    # AppSec as Akamai installation is fucked
RUN yum install -y -q --setopt=tsflags=nodocs git && \
    git clone https://github.com/akamai/cli-appsec /cli/.akamai-cli/src/cli-appsec && \
    rm -rf /cli/.akamai-cli/src/cli-appsec/.git /cli/.akamai-cli/src/cli-appsec/bin/akamai-appsec && \
    wget --quiet -O /cli/.akamai-cli/src/cli-appsec/bin/akamai-appsec https://github.com/akamai/cli-appsec/releases/download/0.1.0/akamai-appsec-0.1.0-linux-amd64 && \
    chmod +x /cli/.akamai-cli/src/cli-appsec/bin/akamai-appsec && \
    yum remove -y -q git && yum autoremove -y && yum clean all && rm -rf /var/cache/yum


ENV AKAMAI_CLI_HOME=/cli
VOLUME /cli
VOLUME /root/.edgerc
