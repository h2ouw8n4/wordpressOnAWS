FROM wordpress:latest
LABEL name="wordpress-memcached"
LABEL authors="Derek Muensterman - https://github.com/h2ouw8n4"

# Install Memcached PHP extension
RUN apt-get update && \
    apt-get install -y unzip libmemcached-dev zlib1g-dev && \
    pecl install memcached && \
    docker-php-ext-enable memcached

# Download and install Memcached plugin
RUN curl -L -O https://downloads.wordpress.org/plugin/memcached.4.0.0.zip && \
    unzip memcached.*.zip -d /usr/src/wordpress/wp-content/plugins && \
    rm memcached.*.zip

# Copy custom.htaccess file and entrypoint.sh script to the Docker image
COPY custom.htaccess /custom.htaccess
COPY entrypoint.sh /entrypoint.sh

# Make sure entrypoint.sh is executable
RUN chmod +x /entrypoint.sh

# Use the entrypoint.sh script as the entrypoint
ENTRYPOINT ["/entrypoint.sh"]