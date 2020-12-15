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


5. Install gems and setup database:
```
docker-compose run runner bundle install && rake db:setup
```

6. Run the containers:
```
docker-compose up -d anycable rails
```

run Rails console if needed:
```
docker-compose run runner
```

#### Classic

3. Install `ruby-2.6.6`


4. Install gems:
```
bundle
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

For run websockets server need install [anycable-go](https://github.com/anycable/anycable-go).
