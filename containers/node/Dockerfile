#
#--------------------------------------------------------------------------
# Image Setup
#--------------------------------------------------------------------------
#

FROM phusion/baseimage:focal-1.0.0

# Add a non-root user to prevent files being created with root permissions on host machine.
ARG PUID=1000
ENV PUID ${PUID}
ARG PGID=1000
ENV PGID ${PGID}

# always run apt update when start and after add new source list, then clean up at end.
RUN set -xe; \
    apt-get update -yqq && \
    groupadd -g ${PGID} phpdev && \
    useradd -l -u ${PUID} -g phpdev -m phpdev -G docker_env && \
    usermod -p "*" phpdev -s /bin/bash && \
    apt-get install -yqq \
    apt-utils git

###########################################################################
# Set Timezone
###########################################################################

ARG TZ=UTC
ENV TZ ${TZ}

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

###########################################################################
# Node / NVM:
###########################################################################

# Check if NVM needs to be installed
ARG NODE_VERSION=node
ENV NODE_VERSION ${NODE_VERSION}
ARG INSTALL_NODE=true
ARG INSTALL_NPM_GULP=true
ARG INSTALL_NPM_BOWER=true
ARG INSTALL_NPM_VUE_CLI=true
ARG INSTALL_NPM_ANGULAR_CLI=true
ARG NPM_REGISTRY
ENV NPM_REGISTRY ${NPM_REGISTRY}
ARG NPM_FETCH_RETRIES
ENV NPM_FETCH_RETRIES ${NPM_FETCH_RETRIES}
ARG NPM_FETCH_RETRY_FACTOR
ENV NPM_FETCH_RETRY_FACTOR ${NPM_FETCH_RETRY_FACTOR}
ARG NPM_FETCH_RETRY_MINTIMEOUT
ENV NPM_FETCH_RETRY_MINTIMEOUT ${NPM_FETCH_RETRY_MINTIMEOUT}
ARG NPM_FETCH_RETRY_MAXTIMEOUT
ENV NPM_FETCH_RETRY_MAXTIMEOUT ${NPM_FETCH_RETRY_MAXTIMEOUT}
ENV NVM_DIR /home/phpdev/.nvm
ARG NVM_NODEJS_ORG_MIRROR
ENV NVM_NODEJS_ORG_MIRROR ${NVM_NODEJS_ORG_MIRROR}

# Install nvm (node version manager)
USER phpdev
RUN set -xe; \
    mkdir -p $NVM_DIR && \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash \
        && . $NVM_DIR/nvm.sh \
        && nvm install ${NODE_VERSION} \
        && nvm use ${NODE_VERSION} \
        && nvm alias ${NODE_VERSION} \
        && npm config set fetch-retries ${NPM_FETCH_RETRIES} \
        && npm config set fetch-retry-factor ${NPM_FETCH_RETRY_FACTOR} \
        && npm config set fetch-retry-mintimeout ${NPM_FETCH_RETRY_MINTIMEOUT} \
        && npm config set fetch-retry-maxtimeout ${NPM_FETCH_RETRY_MAXTIMEOUT} \
        && npm install pm2@latest -g \
        && if [ ${NPM_REGISTRY} ]; then \
        npm config set registry ${NPM_REGISTRY} \
        ;fi


# Set up Oh My BASH! for root user
USER root
RUN set -xe; \
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"

RUN set -xe; \
    sed -i 's/font/90210/g' ~/.bashrc

# Set default work directory
WORKDIR /var/www
