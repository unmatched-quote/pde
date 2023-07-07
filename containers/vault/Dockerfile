FROM phusion/baseimage:focal-1.2.0

RUN set -eux \
    && curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --yes --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list > /dev/null \
    && apt update \
    && apt install -y jq vault

RUN set -eux \
    && mkdir -p /etc/vault.d/policies

# Copy config
COPY ./config/vault.json /etc/vault.d/vault.json

# Copy init script
COPY ./init.d/vault-service.sh /etc/my_init.d/10_vault.init
