FROM postgres:12
MAINTAINER Michael Spitzer <professa@gmx.net>

#######################################################################
# DockerHub / GitHub:
# https://hub.docker.com/r/spitzenidee/postgresql_base/
# https://github.com/spitzenidee/postgresql_base/
#######################################################################

#######################################################################
# Prepare ENVs
ENV PGSQL_HTTP_VERSION        "1.3.1"
ENV PG_CRON_VERSION           "1.2.0"
ENV POWA_ARCHIVIST_VERSION    "3_2_0"
ENV PG_QUALSTATS_VERSION      "1.0.9"
ENV PG_STAT_KCACHE_VERSION    "2_1_1"
ENV HYPOPG_VERSION            "1.1.2"
ENV PG_TRACK_SETTINGS_VERSION "2.0.0"

#######################################################################
# Prepare the build requirements for the rdkit compilation:
RUN apt-get update && apt-get install -y --no-install-recommends \
    postgresql-server-dev-all postgresql-contrib \
    libcurl4-openssl-dev \
    wget jq cmake build-essential ca-certificates && \
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
    wget -O- https://github.com/powa-team/powa-archivist/archive/REL_$POWA_ARCHIVIST_VERSION.tar.gz | tar -xzf - && \
    wget -O- https://github.com/powa-team/pg_qualstats/archive/$PG_QUALSTATS_VERSION.tar.gz | tar -xzf - && \
    wget -O- https://github.com/powa-team/pg_stat_kcache/archive/REL$PG_STAT_KCACHE_VERSION.tar.gz | tar -xzf - && \
    wget -O- https://github.com/HypoPG/hypopg/archive/$HYPOPG_VERSION.tar.gz | tar -xzf - && \
    wget -O- https://github.com/rjuju/pg_track_settings/archive/$PG_TRACK_SETTINGS_VERSION.tar.gz | tar -xzf - && \
    for f in $(ls); do cd $f; make install; cd ..; rm -rf $f; done && \
# Clean up again:
    cd / && \
    rm -rf /build && \
    apt-get remove -y wget jq cmake build-essential ca-certificates && \
    apt-get autoremove --purge -y && \
    apt-get clean && \
    apt-get purge && \
    rm -rf /var/lib/apt/lists/*
# Done.
