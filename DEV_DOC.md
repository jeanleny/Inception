**# Developer Documentation**

# Project deployment

## Installation
You need to install Docker, DockerCompose and Make.

```bash
sudo apt-get update
sudo apt-get install ./docker-desktop-amd64.deb
sudo apt-get install gcc make
DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir -p $DOCKER_CONFIG/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v5.1.2/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
```

Docker also have a group so make sure you are in it : 
```bash
sudo usermod -aG docker $USER
```

You're domain name has to be present in the /etc/hosts file.
So make sure you add <login>.42.fr in it.
```bash
vim /etc/hosts
```

## Credentials
You'll need to add a .env with specific credentials at the docker-compose location :
```config
# MariaDB
MYSQL_ROOT_PASSWORD=XX
MYSQL_DATABASE=XX
MYSQL_USER=XX
MYSQL_PASSWORD=xx
MYSQL_PORT=XX

# WordPress
DOMAIN_NAME=<login>.42.fr
WP_TITLE=Title
WP_ADMIN=XX
WP_ADMIN_PASSWORD=XX
WP_ADMIN_EMAIL=XX@X
WP_USER=XX
WP_USER_EMAIL=XX@XX
WP_USER_PASSWORD=XXX

```


# Build and Launch
You can build the project by using *make* which will use the docker compose up cmd.
You can pause it by using *make down* and delete the volumes by using *make clean*
You can also delete the images with *make fclean*.
*Make re* wipes everything up before restarting the project.

If you want to use Docker Compose instead :
- docker compose up : build and launch the project.
- docker compose down : stops the project without erasing the volumes.

# Commands :
- **docker ps** : is an alias for docker container ls. It lists every container actually running.
- **docker logs <container-name>** : This will show you the logs of the coresponding container. If an error or a loop occurs it will be explicitly shown.
- **docker exec -it <container-name> bash** : If you want to navigate in the container and look for particular things, this opens a bash terminal in the container.
- **docker rmi -f <the-image>** : This stands for Remove Image. Its deletes the images with a certain tag.
- **docker build -t <the-wanted-name> .** : Build a container from a dockerfile present in the actual repo. You can replace the '.' by a path to the dockerfile.
- **docker run <the-image>** : start the builded container.

# Data Persitency :
T
