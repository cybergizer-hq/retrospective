# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* ...

## Development instructions
You can work with project [by docker](#docker) or [classic method](#classic).

1. Clone the project: https://github.com/cybergizer-hq/retrospective


2. In order to skip Alfred login and login with the first seed user
   put `SKIP_ALFRED=true` in your .env file

#### Docker

3.  Install docker:  [docker engine install](https://docs.docker.com/engine/install/ "docker engine install")


4. Install docker-compose: [docker compose install](https://docs.docker.com/compose/install/ "docker compose install")


5. Install gems with node modules and setup database:
```
docker-compose run runner bundle install && yarn && rake db:setup
```

6. Run the containers (first start will be long):
```
docker-compose up -d
```

run Rails console if needed:
```
docker-compose exec runner bash
```

#### Classic

3. Install:

- `ruby-2.6.6` via ruby manager (like a [rvm](https://rvm.io/))
- [postgres 11.1](https://www.postgresql.org/)
- [redis 3.2](https://redis.io/)
- [anycable-go](https://github.com/anycable/anycable-go)


4. Install gems with node modules:
```
bundle && yarn
```
(may need to install a gem `bundle`)


5. Setup database with seeds:
```
rails db:setup
```

6.  Run several servers:

Rails - `rails server`

Websockets - `anycable-go --port=8080`

Rpc - `anycable`
