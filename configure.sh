#!/bin/bash
MODULE_NAME=shiny
RF=$BUILDDIR/${MODULE_NAME}

mkdir -p $RF

DOCKER_HOST=$DOCKERARGS
DOCKER_COMPOSE_FILE=$RF/docker-compose.yml

SHINY_LOG=$LOG_DIR/${MODULE_NAME}
#SHINY_DATA=$DATA_DIR/${MODULE_NAME}
SHINY_TMP=$DATA_DIR/${MODULE_NAMEi}_tmp

case $VERB in
  "build")
    echo "1. Configuring ${PREFIX}-${MODULE_NAME}..."


    mkdir -p $SHINY_LOG $SHINY_TMP #$SHINY_DATA
    docker $DOCKERARGS volume create -o type=none -o device=$SHINY_LOG -o o=bind ${PREFIX}-${MODULE_NAME}-log
#    docker $DOCKERARGS volume create -o type=none -o device=$SHINY_DATA -o o=bind ${PREFIX}-${MODULE_NAME}-apps
    docker $DOCKERARGS volume create -o type=none -o device=$SHINY_TMP -o o=bind ${PREFIX}-${MODULE_NAME}-tmp

    cp Dockerfile etc/index.html $RF/

    sed -e "s/##PREFIX##/$PREFIX/" \
        -e "s/##OUTERHOST##/$OUTERHOST/" \
	-e "s/##MODULE_NAME##/${MODULE_NAME}/" docker-compose.yml-template > $DOCKER_COMPOSE_FILE
    

    sed -e "s/##PREFIX##/${PREFIX}/" \
        -e "s/##OUTERHOST##/$OUTERHOST/" \
         etc/shiny-customized.config-template > $RF/shiny-customized.config

   echo "2. Building ${PREFIX}-${MODULE_NAME}..."
   docker-compose $DOCKER_HOST -f $DOCKER_COMPOSE_FILE build 
 ;;

  "install-hydra")
#    register_hydra $MODULE_NAME
  ;;
  "uninstall-hydra")
#    unregister_hydra $MODULE_NAME
  ;;
  "install-nginx")
    register_nginx $MODULE_NAME
  ;;
  "uninstall-nginx")
    unregister_nginx $MODULE_NAME
  ;;

  "start")
    echo "Starting container ${PREFIX}-${MODULE_NAME}"
    docker-compose $DOCKERARGS -f $DOCKER_COMPOSE_FILE up -d
  ;;

  "init")
  ;;

  "stop")
      echo "Stopping container ${PREFIX}-${MODULE_NAME}"
      docker-compose $DOCKERARGS -f $DOCKER_COMPOSE_FILE down
  ;;
  "remove")
      echo "Removing $DOCKER_COMPOSE_FILE"
      docker-compose $DOCKERARGS -f $DOCKER_COMPOSE_FILE kill
      docker-compose $DOCKERARGS -f $DOCKER_COMPOSE_FILE rm    

  ;;
  "purge")
  ;;

  "cleandata")
    echo "Cleaning data ${PREFIX}-${MODULE_NAME}"
  ;;

  "purge")
###    echo "Removing $RF" 
###    rm -R -f $RF
###    docker $DOCKERARGS volume rm ${PREFIX}-${MODULE_NAME}-data
  ;;

esac
