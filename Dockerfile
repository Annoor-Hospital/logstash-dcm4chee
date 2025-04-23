FROM logstash:8.17.2

RUN /usr/share/logstash/bin/logstash-plugin install --version 5.0.0 logstash-codec-frame && \
    /usr/share/logstash/bin/logstash-plugin install --version 6.4.3 logstash-filter-hashtree && \
    /usr/share/logstash/bin/logstash-plugin install logstash-output-gelf

COPY logstash.yml /usr/share/logstash/config/logstash.yml
COPY pipeline.conf /etc/pipeline.conf
COPY certs /etc/certs

ENV GRAYLOG_HOST=graylog \
    GRAYLOG_PORT=12201 \
    SYSLOG_UDP_PORT=8514 \
    SYSLOG_TCP_PORT=8514 \
    SYSLOG_TLS_PORT=6514 \
    SSL_CERT=/etc/certs/cert.pem \
    SSL_EXTRA_CHAIN_CERTS=/etc/certs/ca.pem \
    SSL_KEY=/etc/certs/key.pem \
    SSL_VERIFY=false \
    SSL_CERTIFICATE_AUTHORITIES=/etc/certs/ca.pem \
    MANAGE_TEMPLATE=true \
    HASHTREE_TARGET=fingerprint \
    HASHTREE_PREVIOUS=fingerprint_previous \
    HASHTREE_FILE=/usr/share/logstash/data/filter-hashtree \
    HASHTREE_METHOD=SHA1 \
    HL7_CHARSET=ISO-8859-1

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["logstash", "-f", "/etc/pipeline.conf"]
