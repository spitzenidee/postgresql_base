# postgresql_base
A Dockerfile integrating Postgresql with some "base" extensions, to build upon with downstream Dockerfiles

# Purpose
This Dockerfile builds a Postgresql image and integrates with
* PGSQL_HTTP, version 1.2.2 (https://github.com/pramsey/pgsql-http)
* PG_CRON, version 1.0.2 (https://github.com/citusdata/pg_cron)
* POWA Archivist, version 3_1_1 (https://github.com/dalibo/powa-archivist), incl. HypoPG (https://github.com/dalibo/hypopg) etc.

Based on this Dockerfile and the automated build on DockerHub (https://hub.docker.com/r/spitzenidee/postgresql_base/) more "specified" Postgresql images can be set up, e.g.
* RDKit
* TimescaleDB (https://github.com/spitzenidee/postgresql_timescaledb)
* MADBlib
* or a combination of those (https://github.com/spitzenidee/postgresql_scientific).

# How to start and set up a container of "spitzenidee/postgresql_base"
* `docker pull spitzenidee/postgresql_base:latest`
* `docker run -d --name postgresql_base --restart unless-stopped -p 5432:5432 -v <static_pgsql_files>:/var/lib/postgresql/data spitzenidee/postgresql_base:latest`

# Edit "postgresql.conf"
* `docker stop postgresql_base`
* Edit "<static_pgsql_files>/postgresql.conf" and the parameters "shared_preload_libraries" and "track_io_timing" as follows:
* `shared_preload_libraries = 'pg_stat_statements,powa,pg_qualstats,pg_stat_kcache,pg_cron'`
* `track_io_timing = on`
* `docker start postgresql_base`

# Set up PG_CRON and PGSQL_HTTP
Use your favorite SQL command line or UI tool to create extensions in your selected database (as a Postgresql superuser, such as "postgres", and possibly in the database "postgres" if you're on defaults from this container image).
* `SET AUTOCOMMIT=ON;`
* `CREATE EXTENSION http;`
* `CREATE EXTENSION pg_cron;`
* `GRANT USAGE ON SCHEMA cron TO regular_pgsql_user;`

# Now for setting up POWA
The following commands where taken from "https://github.com/dalibo/docker/blob/master/powa/powa-archivist/install_all.sql".
* `-- Connect to your database as a superuser:`
* `SET AUTOCOMMIT=ON;`
* `CREATE EXTENSION hypopg;`
* `CREATE database powa;`
* `SET AUTOCOMMIT=OFF;`
* `-- Reconnect to database "powa"`
* `SET AUTOCOMMIT=ON;`
* `CREATE EXTENSION pg_stat_statements;`
* `CREATE EXTENSION btree_gist;`
* `CREATE EXTENSION pg_qualstats;`
* `CREATE EXTENSION pg_stat_kcache;`
* `CREATE EXTENSION pg_track_settings;`
* `CREATE EXTENSION powa;`
* `SET AUTOCOMMIT=OFF;`
* `-- Reconnect to database "template1"`
* `SET AUTOCOMMIT=ON;`
* `CREATE EXTENSION hypopg;`
* `SET AUTOCOMMIT=OFF;`

Also make sure to read the documentations (via the links above) of the individual extensions if you run into any woes.

# Connect to POWA-Archivist via POWA-Web
* `docker pull dalibo/powa-web`
* `docker run -d --name powa_web --restart unless-stopped -p 8888:8888 --link postgresql_base:powa-archivist dalibo/powa-web:latest`
You can now access the POWA web interface via "http://yourdockerhost:8888/" and log in e.g. via the superuser "postgres" (highly insecure, please read the POWA documentation on how to secure it properly: http://powa.readthedocs.io/en/latest/security.html).

# Have fun!
Do it! :-)
