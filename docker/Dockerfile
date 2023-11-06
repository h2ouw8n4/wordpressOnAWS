FROM --platform=linux/arm64/v8 wordpress:latest
LABEL name="wp-memcache"
LABEL authors="Derek Muensterman - https://github.com/h2ouw8n4"

# Install Memcache PHP extension
RUN apt update
RUN apt install -y unzip zlib1g zlib1g-dev libssl-dev
RUN pecl install memcache docker-php-ext-enable memcache


# Download and install Total Cache plugin
RUN curl -o w3-total-cache.zip -L -O https://downloads.wordpress.org/plugin/w3-total-cache.2.5.0.zip && \
    unzip w3-total-cache.zip -d /usr/src/wordpress/wp-content/plugins && \
    rm w3-total-cache.zip

RUN curl -o latest-64bit -L -O https://elasticache-downloads.s3.amazonaws.com/ClusterClient/PHP-8.0/latest-64bit-arm-openssl1.1 && \
    tar -zxvf latest-64bit && \
    chmod o+x ./amazon-elasticache-cluster-client.so && \
    chown root:root ./amazon-elasticache-cluster-client.so && \
    mv ./amazon-elasticache-cluster-client.so /usr/local/lib/php/extensions/no-debug-non-zts*/ && \
    echo "extension=amazon-elasticache-cluster-client.so" | tee --append /usr/local/etc/php/conf.d/50-memcached.ini

# Copy custom .htaccess
COPY custom.htaccess /usr/src/wordpress/.htaccess

#RUN mv /usr/src/wordpress/wp-content/plugins/memcached/object-cache.php /usr/src/wordpress/wp-content/object-cache.php

RUN random_string=$(LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 50) && \
    sed -i "/* That's all, stop editing! Happy publishing. */i \define( 'WP_CACHE_KEY_SALT', '${random_string}' );" /usr/src/wordpress/wp-config-docker.php

RUN sed -i "/* That's all, stop editing! Happy publishing. */i \$memcached_servers = array('default' => array(getenv_docker('WP_MEMCACHED_ENDPOINT', '')));" /usr/src/wordpress/wp-config-docker.php
