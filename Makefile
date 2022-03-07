build: # build fresh images
	docker-compose build --pull --no-cache

start: # the logs will be displayed in the current shell
	docker-compose up

stop: # stop the Docker containers
	docker-compose down --remove-orphans
