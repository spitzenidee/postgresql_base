# postgresql_base
A Dockerfile integrating Postgresql with some "base" extensions, to build upon with downstream Dockerfiles

# Purpose
This Dockerfile builds a Postgresql image and integrates with
* PGSQL_HTTP, version 1.2.2 (https://github.com/pramsey/pgsql-http)
* PG_CRON, version 1.0.2 (https://github.com/citusdata/pg_cron)
* POWA Archivist, version 3_1_1 (https://github.com/dalibo/powa-archivist)

Based on this Dockerfile and the automated build on DockerHub () more "specified" Postgresql images can be set up, e.g.
* RDKit
* TimescaleDB (https://github.com/spitzenidee/postgresql_timescaledb)
* MADBlib
* or a combination of those (https://github.com/spitzenidee/postgresql_scientific).
