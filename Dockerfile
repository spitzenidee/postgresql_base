FROM postgres:10.1
MAINTAINER Michael Spitzer <professa@gmx.net>

#######################################################################
# DockerHub / GitHub:
# https://hub.docker.com/r/spitzenidee/postgresql_rdkit_timescaledb/
# https://github.com/spitzenidee/postgresql_rdkit_timescaledb
#######################################################################

#######################################################################
# Prepare ENVs
ENV PGSQL_HTTP_VERSION "1.2.2"
ENV PG_CRON_VERSION    "1.0.2"
ENV POWA_VERSION       "3_1_1"

#######################################################################
# Prepare the build requirements for the rdkit compilation:
RUN apt-get update && apt-get install -y \
    postgresql-server-dev-all \
    postgresql-contrib \
    #libcurl4-nss-dev \
    libcurl4-openssl-dev \
    #libcurl4-gnutls-dev \
    git \
    wget \
    cmake \
    build-essential && \
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
    wget https://github.com/dalibo/powa-archivist/archive/REL_$POWA_VERSION.tar.gz && \
    tar zxvf REL_$POWA_VERSION.tar.gz && \
    cd powa-archivist-REL_$POWA_VERSION && \
    make && \
    make install && \
# Clean up again:
    cd / && \
    rm -rf /build && \
    apt-get remove -y git wget cmake build-essential && \
    apt-get autoremove --purge -y && \
    apt-get clean && \
    apt-get purge && \
    rm -rf /var/lib/apt/lists/*

# Done.
