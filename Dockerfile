FROM postgres:10.1
MAINTAINER Michael Spitzer <professa@gmx.net>

#######################################################################
# DockerHub / GitHub:
# https://hub.docker.com/r/spitzenidee/postgresql_base/
# https://github.com/spitzenidee/postgresql_base/
#######################################################################

#######################################################################
# Prepare ENVs
ENV PGSQL_HTTP_VERSION "1.2.2"
ENV PG_CRON_VERSION    "1.0.2"

#######################################################################
# Prepare the build requirements for the rdkit compilation:
RUN apt-get update && apt-get install -y \
    postgresql-server-dev-all postgresql-contrib \
    #libcurl4-nss-dev libcurl4-gnutls-dev \
    libcurl4-openssl-dev \
    wget jq cmake build-essential && \
# Install PGSQL_HTTP:
    mkdir /build && \
    cd /build && \
    wget https://github.com/pramsey/pgsql-http/archive/v$PGSQL_HTTP_VERSION.tar.gz && \
    tar xzvf v$PGSQL_HTTP_VERSION.tar.gz && \
    cd pgsql-http-$PGSQL_HTTP_VERSION && \
    make && \
    make install && \
# Install PG_CRON:
    cd /build && \
    wget https://github.com/citusdata/pg_cron/archive/v$PG_CRON_VERSION.tar.gz && \
    tar xzvf v$PG_CRON_VERSION.tar.gz && \
    cd pg_cron-$PG_CRON_VERSION && \
    make && \
    make install && \
# Install POWA:
    cd /build && \
    mkdir powa && \
    cd powa && \
    wget -O- $(wget -O- https://api.github.com/repos/dalibo/powa-archivist/releases/latest|jq -r '.tarball_url') | tar -xzf - && \
    wget -O- $(wget -O- https://api.github.com/repos/dalibo/pg_qualstats/releases/latest|jq -r '.tarball_url') | tar -xzf - && \
    wget -O- $(wget -O- https://api.github.com/repos/dalibo/pg_stat_kcache/releases/latest|jq -r '.tarball_url') | tar -xzf - && \
    wget -O- $(wget -O- https://api.github.com/repos/dalibo/hypopg/releases/latest|jq -r '.tarball_url') | tar -xzf - && \
    wget -O- $(wget -O- https://api.github.com/repos/rjuju/pg_track_settings/releases/latest|jq -r '.tarball_url') | tar -xzf - && \
    for f in $(ls); do cd $f; make install; cd ..; rm -rf $f; done && \
# Clean up again:
    cd / && \
    rm -rf /build && \
    apt-get remove -y wget jq cmake build-essential && \
    apt-get autoremove --purge -y && \
    apt-get clean && \
    apt-get purge && \
    rm -rf /var/lib/apt/lists/*
# Done.
