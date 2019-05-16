FROM debian:stretch
MAINTAINER JAGM2019 <nowherem4n@thevoid.go>

## Install tools and libraries
RUN apt-get update -yqq && \
    apt-get install -yqq --no-install-recommends \
        procps \
        xinetd \
	amqp-tools \
        ca-certificates \
        fetchmail \
        curl \
        openssl \
        ssl-cert \
	supervisor && \
# Clean up
    apt-get autoremove -y && \
    apt-get clean && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /usr/local/share/man /var/cache/debconf/*-old

# Copy files to docker
COPY entrypoint.sh /entrypoint.sh
COPY fetchmailer.sh /root/fetchmailer.sh
COPY healthcheck.sh /root/healthcheck.sh
COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY healthcheck-stream /etc/xinetd.d/healthcheck-stream

RUN chmod +x /entrypoint.sh && \
    chmod +x /root/fetchmailer.sh && \
    chmod +x /root/healthcheck.sh && \
    echo "healthcheck     9090/tcp" >> /etc/services

EXPOSE 9090

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
