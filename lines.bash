#!/bin/bash

FILE=`< docker-compose.yaml`

printf "%q" "$FILE" 
