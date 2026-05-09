**# User Documentation**

# Services
Each service has its own functionnality.

## Nginx :
Serves a a web server. The only entry point of the website.
It handles every incoming connections and redirect them to the right service.
It is nginx that creates a SSL certificate and key and manage the HTTPS connections.

## Mariadb :
This is the database. It stores all the Wordpress database such as users, posts, settings...

## Wordpress :
Wordpress is website application that can be easily maintained by non-developper.
It works with a FastCGI interface, in this case PHP-FPM as been installed.
This container also contains the WordPress CLI to configure WordPress via Terminal command.

# Basic Command 
You can build the project by using *make* which will use the docker compose up cmd.
You can pause it by using *make down* and delete the volumes by using *make clean*
You can also delete the images with *make fclean*.
*Make re* wipes everything up before restarting the project.

# Website
Once the environment up, you can use the localhost or lperis.42.fr domain name to visit the wordpress.
*https://localhost/*
*https://lperis.42.fr/*

If you want to connect with a certain user add the *wp-admin* after the url.
*https://lperis.42.fr/wp-admin*

Its here where you can connect as the admin and access the control pannel : *see credentials*.

# Credentials
All the credentials are stored in the .env file.
This stores the admin username and password.
There's also the mysql password to navigate in the DB.

# Services Health Check
To check if the services are running you can use differents commands.
- **docker ps** : is an alias for docker container ls. It lists every container actually running.
- **docker logs <container-name>** : This will show you the logs of the coresponding container. If an error or a loop occurs it will be explicitly shown.
- **docker exec -it <container-name> bash** : If you want to navigate in the container and look for particular things, this opens a bash terminal in the container.

