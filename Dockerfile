FROM centos:8

COPY google-chrome.repo /etc/yum.repos.d/google-chrome.repo

RUN dnf clean all && \
    dnf upgrade -y && \
    dnf update -y && \
    dnf -y install yum-utils

RUN dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y && \
    dnf module enable php:remi-7.4 -y

RUN yum install dnf-plugins-core && \
    yum config-manager --set-enabled powertools && \
    yum install -y --nogpgcheck \
    epel-release \
    google-chrome-stable \
    wget \
    git \
    nano \
    postfix \
    gcc-c++ \
    make \
    sqlite \
    sqlite-devel \
    mysql \
    zlib-devel \
    libicu-devel \
    gcc \
    freetype-devel \
    libjpeg-turbo-devel \
    libmcrypt-devel \
    libpng-devel \
    openssl-devel \
    curl-devel \
    libxml2-devel \
    gnupg2 \
    xorg-x11-server-Xvfb \
    gtk2 \
    libnotify-devel \
    GConf2 \
    nss \
    libXScrnSaver \
    alsa-lib \
    nginx \
    libXtst \
    libXtst-devel \
    php \
    php-bcmath \
    php-cli \
    php-curl \
    php-devel \
    php-gd \
    php-fpm \
    php-imagick \
    php-imap \
    php-intl \
    php-mbstring \
    php-mcrypt \
    php-mysqlnd \
    php-opcache --nogpgcheck \
    php-pdo \
    php-pear \
    php-posix \
    php-xml \
    php-zip \
    librabbitmq \
    librabbitmq-devel \
    unzip

RUN pecl config-set php_ini /etc/php.ini && \
    pecl channel-update pecl.php.net && \
    printf "\n" | pecl install amqp && \
    echo "extension=amqp" >> /etc/php.ini

RUN curl https://phar.phpunit.de/phpunit.phar -L -o phpunit.phar && \
    chmod +x phpunit.phar && \
    mv phpunit.phar /usr/local/bin/phpunit

ARG composer_hash=756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('SHA384', 'composer-setup.php') === '$composer_hash') { echo 'Installer verified'; } else { echo 'Installer corrupt. Maybe a new version was released and you forgot to update the verification hash?'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar /usr/local/bin/composer

RUN export CHROME_DRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE` && \
    wget -N https://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip -P ~/ && \
    unzip /root/chromedriver_linux64.zip -d ~/ && \
    rm ~/chromedriver_linux64.zip && \
    mv -f ~/chromedriver /usr/local/bin/chromedriver && \
    chown root:root /usr/local/bin/chromedriver && \
    chmod 0755 /usr/local/bin/chromedriver

RUN curl --silent --location https://rpm.nodesource.com/setup_14.x | bash - && \
    dnf install -y nodejs

WORKDIR /html

STOPSIGNAL SIGTERM

COPY php.ini /etc/php.d/01-docker.ini
