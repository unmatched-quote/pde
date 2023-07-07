#
#--------------------------------------------------------------------------
# Image Setup
#--------------------------------------------------------------------------
#

FROM phusion/baseimage:focal-1.0.0

ENV DEBIAN_FRONTEND=noninteractive
RUN locale-gen en_US.UTF-8

ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LC_CTYPE=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV TERM xterm

RUN set -eux \
    # Add the "PHP 8" ppa
    && apt-get install -y software-properties-common \
    && add-apt-repository -y ppa:ondrej/php \
    #
    #--------------------------------------------------------------------------
    # Software's Installation
    #--------------------------------------------------------------------------
    #
    && echo 'DPkg::options { "--force-confdef"; };' >> /etc/apt/apt.conf \
    # Install "PHP Extentions", "libraries", "Software's"
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --allow-downgrades --allow-remove-essential \
        --allow-change-held-packages \
        php8.1-cli \
        php8.1-common \
        php8.1-curl \
        php8.1-intl \
        php8.1-xml \
        php8.1-mbstring \
        php8.1-mysql \
        php8.1-pgsql \
        php8.1-sqlite \
        php8.1-sqlite3 \
        php8.1-zip \
        php8.1-bcmath \
        php8.1-memcached \
        php8.1-gd \
        php8.1-dev \
        pkg-config \
        libcurl4-openssl-dev \
        libedit-dev \
        libssl-dev \
        libxml2-dev \
        xz-utils \
        libsqlite3-dev \
        rsync \
        sqlite3 \
        git \
        curl \
        vim \
        nano \
        tree \
        postgresql-client \
    && apt-get clean \
    #####################################
    # Composer:
    #####################################
    # Install composer and add its bin to the PATH.
    && curl -s http://getcomposer.org/installer | php \
    && echo "export PATH=${PATH}:/var/www/vendor/bin" >> ~/.bashrc \
    && mv composer.phar /usr/local/bin/composer


# Add a non-root user to prevent files being created with root permissions on host machine.
ARG PUID=1000
ENV PUID ${PUID}
ARG PGID=1000
ENV PGID ${PGID}

# always run apt update when start and after add new source list, then clean up at end.
RUN set -xe; \
    apt-get update -yqq && \
    pecl channel-update pecl.php.net && \
    groupadd -g ${PGID} phpdev && \
    useradd -l -u ${PUID} -g phpdev -m phpdev -G docker_env && \
    usermod -p "*" phpdev -s /bin/bash && \
    apt-get install -yqq \
      libargon2-1 libidn2-0 libpcre2-8-0 libpcre3 libxml2 libzstd1 apt-utils \
      #
      #--------------------------------------------------------------------------
      # Mandatory Software's Installation
      #--------------------------------------------------------------------------
      #
      # Mandatory Software's such as ("php-cli", "git", "vim", ....) are
      # installed on the base image 'laradock/workspace' image. If you want
      # to add more Software's or remove existing one, you need to edit the
      # base image (https://github.com/Laradock/workspace).
      #
      # next lines are here because there is no auto build on dockerhub see https://github.com/laradock/laradock/pull/1903#issuecomment-463142846
      libzip-dev zip unzip \
      # Install the zip extension
      php8.1-zip \
      # nasm
      nasm && \
      php -m | grep -q 'zip'

# Set up Oh My BASH! for root user
USER root
RUN set -xe; \
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"

RUN set -xe; \
    sed -i 's/font/90210/g' ~/.bashrc

WORKDIR /var/www