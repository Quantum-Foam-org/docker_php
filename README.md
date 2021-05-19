# Quantum Foam Docker 

- Once checked out **run commnad** `bash init.bash` 
- Next **start** the docker containers `sudo docker-compose up`
  - If this fails I have had current success **running** `sudo docker system prune`
  - after running prune then run `bash init.bash` one more time
- Once the containers are up and running **run** the following `sudo docker-compose exec mysql bash /opt/service/quantum_foam/install.bash`
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
** All docker commands require sudo.  It is recommended by the debian documentation. https://wiki.debian.org/Docker***
