*This project has been created as part of the 42 curriculum by lperis*

# **Description** : 
Inception is a Devops project that serve as an introduction to the docker uses.
Docker is a building platform tool that can runs multiple applications in the same time.
It uses containers that host every applications by using images.
Images are the actual applications you want, usually you call official image by using docker hub.
But in Inception you have to build the whole image from scratch.

The subject requires you to create a docker environment that contains:
- Nginx web server
- Wordpress configuration with PHP_FPM to handle FastCGI and WP CLI to allow Wordpress configuration with the terminal commands.
- Mariadb database.
Database and wordpress files are both stored in separate volumes. It allows data persistency.
A docker compose is mandatory to build the environment. Its a docker configuration file in .YAML that contains all the docker instructions.

# **Instructions** : 
The whole environmment is launched via a Makefile that calls a docker-compose.
Makefile command :
- **make** : build and run the docker environment via *docker compose up*
- **down** : pauses the different containers without deleting the volumes so it can be restarded later.
- **clean**: removes the volumes containing wp files and database.
- **fclean** : delete all the images and calls the clean cmd.
- **re** : call the fclean then the make cmd.

When the website is up, you can access it with the localhost or lperis.42.fr domain name :
- https://localhost/
- https://lperis.42.fr/

# **Resources** :

## Docker
dockerfile references : *https://docs.docker.com/reference/dockerfile/*
dockercompose references : *https://docs.docker.com/reference/compose-file/*
Services references : *https://docs.docker.com/reference/compose-file/services/*
Volumes references : *https://docs.docker.com/reference/compose-file/volumes/*
Networkd references : *https://docs.docker.com/reference/compose-file/networks/*
Every Command line (CLI) : *https://docs.docker.com/reference/cli/docker/* 

## Nginx
beginner guide : *https://nginx.org/en/docs/beginners_guide.html*
https server guide : *https://nginx.org/en/docs/http/configuring_https_servers.html*
SSL Wiki : *https://fr.wikipedia.org/wiki/Transport_Layer_Security*
SSL guide/doc : *https://docs.openssl.org/master/man7/ossl-guide-introduction/*

## Mariadb
mariadb begginer guide : *https://mariadb.com/docs/server/mariadb-quickstart-guides/basics-guide*
mariadb cheatsheet : *https://mariadb.com/wp-content/uploads/2021/08/mariadb-standard-developer_cheat-sheet_1113.pdf*

## WordPress
install wordpress with nginx and my SQL : *https://www.ionos.com/digitalguide/hosting/blogs/wordpress-nginx/*
install wordpress with nginx video : *https://www.youtube.com/watch?v=1Haj2D_WTCY*

## AI 
Ai was used to help debug the different images problem and understand the new concept.

# Project description
Docker is a building platform tool that can runs multiple applications in the same time.
It uses containers that host every applications by using images.
For the reference see the **Ressources/Docker** section.
## Virtual Machines vs Docker : 
A VM simulates a whole computer with his own OS.
So it has also his own storage his own memory that makes it completely independent.
This is being simulated by what we call an hypervisor (VirtualBox).

A container uses the same OS, so they have the same kernel features, such as devices fd's, processes, memory or CPU.
Which means that we can use files created localy and export them to the container.

## Secrets vs Environment Variables
Each of them are just a way to secure credentials.
Credentials are basically config or user password that users shouldn't access.
Docker secrets are a special feature where you can store credential in a safer way.
Environment variables are also used by docker in an .env file that stores credentials.

## Docker Network vs Host Network
For the containers, Host network is the machine network, the linux one.
So they share the same port, the same ip adress.
In our case, we want our container to behave like independent machines.
Nginx need his own port, like mariadb with port 3306 and wordpress with 9000.
So we create a docker network in our dockercompose and we place each container in it.

## Docker Volumes vs Bind Mounts
Bind mounts are specific container that are stored in the container.
If you stop the container, the data is lost.
Docker volume are "path" to folder created locally where the container picks the data.
In our case, the volumes are created in the /home/lperis/folder/ and linked via docker compose at the volume section.
So even if the containers are down if you didn't deleted them it stays persistent.
