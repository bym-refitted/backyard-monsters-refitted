FROM node:22-alpine

RUN mkdir /app

WORKDIR /app

COPY . /app

RUN npm i

RUN chmod +x scripts/*.sh

# MariaDB Client needed for check if db has to be initialized. see scripts/try-init-db.sh
RUN apk add mariadb-client

ENTRYPOINT ["scripts/docker-start-web.sh"]
# ENTRYPOINT ["npm", "run", "serve"]