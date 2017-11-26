# postgresql_base
A Dockerfile integrating Postgresql with some "base" extensions, to build upon with downstream Dockerfiles

# Purpose
This Dockerfile builds a Postgresql image and integrates with
* PGSQL_HTTP (https://github.com/pramsey/pgsql-http)
* PG_CRON (https://github.com/citusdata/pg_cron)
* POWA Archivist (https://github.com/dalibo/powa-archivist)

Based on this Dockerfile and the automated build on DockerHub () more "specified" Postgresql images can be set up, e.g.
* RDKit
* TimescaleDB
* MADBlib
* or a combination of those.
