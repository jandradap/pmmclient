FROM debian:jessie-slim

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
			org.label-schema.name="pmmclient" \
			org.label-schema.description="pmmclient - Client PMM (Percona Monitoring and Management)" \
			org.label-schema.url="http://andradaprieto.es" \
			org.label-schema.vcs-ref=$VCS_REF \
			org.label-schema.vcs-url="https://github.com/jandradap/pmmclient" \
			org.label-schema.vendor="Jorge Andrada Prieto" \
			org.label-schema.version=$VERSION \
			org.label-schema.schema-version="1.0" \
			maintainer="Jorge Andrada Prieto <jandradap@gmail.com>" \
			org.label-schema.docker.cmd=""

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    wget \
    openssl \
    ca-certificates \
    percona-toolkit \
  && wget https://repo.percona.com/apt/percona-release_0.1-4.jessie_all.deb \
  && dpkg -i percona-release_0.1-4.jessie_all.deb \
  && rm percona-release_0.1-4.jessie_all.deb \
  && apt-get update \
  && apt-get install pmm-client \
  && rm -rf /var/lib/apt/lists/* /tmp/*

COPY docker-entrypoint.sh /usr/local/bin/

WORKDIR /usr/local/percona/pmm-client

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["pmm-admin"]
