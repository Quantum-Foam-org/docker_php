# Quantum Foam Docker 

- Once checked out **run commnad** `bash init.bash` 
- Next **start** the docker containers `sudo docker-compose up`
  - If this fails I have had current success **running** `sudo docker system prune`
  - after running prune then run `bash init.bash` one more time
- Once the containers are up and running and the MySQL container is fully initialized **run** the following `sudo docker-compose exec mysql bash /opt/service/quantum_foam/install.bash`
  - The MySQL container is fully initialized when you can log in with user and password root
```
This will install the HTTP_Testing_Utilities curlHTTPWebSpider database and user.
Next you can run the HTTP_Testing_Utilities after starting a shell on the docker php instance
To start a shell in the docker php instance **run the command** `sudo docker-compose exec php sh`
apps are **located** in */var/www/html*
```

### Running the following should start the spider ###
```
cd /var/www/html/php/HTTP_Testing_Utilities && php curlHTTPWebSpider.php --startUrl=http://openbsd.org
less /tmp/php_http_testing_utilities.log
```
**All docker commands require sudo.  It is recommended by the debian documentation. https://wiki.debian.org/Docker**
```
visudo and add this command for your user or group "%users ALL = (docker:docker) /usr/bin/docker, /usr/bin/docker-compose"
When running docker or docker-compose do the following `sudo -u(your_user) -gdocker docker`
```
