FROM wordpress:latest
LABEL name="wp-memcache"
LABEL authors="Derek Muensterman - https://github.com/h2ouw8n4"

# Install Memcache PHP extension
RUN apt-get update && \
    apt-get install -y unzip zlib1g-dev && \
    pecl install memcache && \
    docker-php-ext-enable memcache

# Download and install Memcached plugin
RUN curl -o memcached.zip -L -O https://downloads.wordpress.org/plugin/memcached.4.0.0.zip && \
    unzip memcached.zip -d /usr/src/wordpress/wp-content/plugins && \
    rm memcached.zip

# Copy custom .htaccess
COPY custom.htaccess /usr/src/wordpress/.htaccess

RUN mv /usr/src/wordpress/wp-content/plugins/memcached/object-cache.php /usr/src/wordpress/wp-content/object-cache.php

RUN random_string=$(LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 50) && \
    sed -i "/* That's all, stop editing! Happy publishing. */i\define( 'WP_CACHE_KEY_SALT', '${random_string}' );" /usr/src/wordpress/wp-config-docker.php

RUN sed -i "/* That's all, stop editing! Happy publishing. */i \$memcached_servers = array('default' => array(\$WP_MEMCACHED_ENDPOINT));" /usr/src/wordpress/wp-config-docker.php

RUN sed -i '/list ( \$node, \$port ) = explode( /i printf("%s", \$server);' /usr/src/wordpress/wp-content/object-cache.php

RUN cat /usr/src/wordpress/wp-content/object-cache.php
