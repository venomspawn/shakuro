# Books accounting microservice

Implementation of microservice for [test exam on back-end developer position in
Shakuro](https://shakurocom.github.io/BackEnd-Test/). The project uses the
following technologies:

*   [PostgreSQL](https://www.postgresql.org/) as RDBMS;
*   [Ruby](https://www.ruby-lang.org/en/) as main programming language;
*   [Thin](https://github.com/macournoyer/thin) and
    [Puma](https://github.com/puma/puma) as HTTP-servers;
*   [Sinatra](https://github.com/sinatra/sinatra) as DSL for REST API
    definitions;
*   [Sequel](https://github.com/jeremyevans/sequel) as ORM;
*   [RSpec](https://github.com/rspec/rspec) for tests definitions and
    launching;
*   and also some other awesome libraries which names can be found in `Gemfile`
    of the project.

## Usage

Although it's not required, it's highly recommended to use the project in a
virtual machine. The project provides Vagrantfile to automatically deploy and
provision virtual machine with use of [VirtualBox](https://www.virtualbox.org/)
and [vagrant](https://www.vagrantup.com/) tool. One can use `vagrant up` in the
root directory of the cloned project to launch virtual machine and `vagrant
ssh` to enter it after boot. The following commands should be of use in the
terminal of virtual machine:

*   `bundle install` — install required libraries used by the project;
*   `make migrate` — migrate primary database (required before first
    development or production run);
*   `RACK_ENV=test make migrate` — migrate test database (required before first
    tests run);
*   `make debug` — launch debug console application;
*   `make test` — run tests;
*   `make run` — run service in development mode with Thin server;
*   `RACK_ENV=production make run` — run service in production mode with Puma
    server.

## Options

The service supports configuring via environment variables. Some of their
values get loaded from `.env.*` files of the root directory of the project.

### Rack options

*   `RACK_ENV` — sets RACK environment and supports the following values:
    `development` (default), `test`, and `production`.

### Log options

*   `SHAKURO_LOG_LEVEL` — sets log output level and supports the following
    values: `debug`, `info`, `warn`, `error`, and `unknown` (the latter
    supresses almost all log output).

### REST-controller options

*   `SHAKURO_BIND_HOST` — binding address for listening.
*   `SHAKURO_PORT` — port for listening.
*   `SHAKURO_PUMA_WORKERS` — number of child puma processes (default value is
    4).
*   `SHAKURO_PUMA_THREADS_MIN` — minimal number of puma threads in every child
    process (default value is 0).
*   `SHAKURO_PUMA_THREADS_MAX` — maximal number of puma threads in every child
    process (default value is 8).

### Database connection options

*   `SHAKURO_DB_HOST` — address of database server.
*   `SHAKURO_DB_NAME` — name of database.
*   `SHAKURO_DB_USER` — user of database.
*   `SHAKURO_DB_PASS` — password of database.

## Documentation

The project uses in-code documentation in [`yard`](https://yardoc.org) format.
One can invoke `make doc` command to translate the documentation to HTML (it
will appear in `doc` directory in the project).
