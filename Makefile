include srcs/.env

all	:
	mkdir -p /home/lperis/data/mariadb
	mkdir -p /home/lperis/data/wordpress
	docker compose -f ./srcs/docker-compose.yaml up -d --build
down	:
	docker compose -f ./srcs/docker-compose.yaml down

clean	: down
	sudo rm -rf /home/lperis/data/wordpress
	sudo rm -rf /home/lperis/data/mariadb

fclean	: clean
	docker system prune --all --force

re	: clean all

.PHONY : all down clean fclean re
