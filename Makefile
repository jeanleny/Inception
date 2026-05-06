include srcs/.env

all: up

up :
	mkdir -p /home/lperis/data/wp/webfiles
	mkdir -p /home/lperis/data/wp/db
	docker compose -f ./srcs/docker-compose.yaml up
down :
	docker compose -f ./srcs/docker-compose.yaml down -v

clean : down
	rm -rf /home/lperis/data/wp/webfiles
	rm -rf /home/lperis/data/wp/db
