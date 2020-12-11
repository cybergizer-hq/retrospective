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

1.  Install docker:  [docker engine install](https://docs.docker.com/engine/install/ "docker engine install")


2. Install docker-compose: [docker compose install](https://docs.docker.com/compose/install/ "docker compose install")


3. Clone the project: https://github.com/cybergizer-hq/retrospective


4. Create and setup postgres db:
```
docker-compose run rake db:create db:setup
```


5. Run the containers:
```
docker-compose up -d rails
```

run Rails console if needed:
```
docker-compose run runner
```

6. In order to skip Alfred login and login with the first seed user
   put `SKIP_ALFRED=true` in your .env file
