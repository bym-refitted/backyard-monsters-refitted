#!/bin/bash

# READ ME!
# This script is meant to run inside the web container of the docker-compose runtime. 
# It checks if the most important tables exist in the database. If they do not exist, the db:init script is run
# This script expects environment variables to be present, which are automatically passed by the docker_compose.yml file:
# DB_HOST       => The hostname of the database 
# DB_USER       => Database Username
# DB_PASSWORD   => The password for the database user
# DB_NAME       => The name of the database

function sql {
    mariadb -h $DB_HOST -u $DB_USER -p$DB_PASSWORD -D "$DB_NAME" -e "$1" -r
    return $?
}

function tbl_exists {
    tbl=$1
    sql "SELECT 1 as 'Exists' FROM $tbl LIMIT 1" > /dev/null
    res=$?
    if [[ res -eq 0 ]] then
        echo "Table $tbl exists"
        return 0
    else
        echo "Table $tbl does not exist!"
        return 1
    fi
    return $res
}

echo "==== Checking if database needs to be initialized ===="

# add tables in this command chain
tbl_exists user && tbl_exists save && DB_INITIALIZED=1 || DB_INITIALIZED=0

if [[ $DB_INITIALIZED -eq 0 ]]; then
    echo "Initializing DB"
    npm run db:init
else
    echo "Database already initialized"
fi

echo "==== Check finished ===="
echo ""