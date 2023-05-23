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

# Copy .htaccess file from project directory
COPY .htaccess /usr/src/wordpress/.htaccess

# Set ownership of .htaccess file to www-data
RUN chown www-data:www-data /usr/src/wordpress/.htaccess

# Set permissions of .htaccess file to 644
RUN chmod 644 /usr/src/wordpress/.htaccess