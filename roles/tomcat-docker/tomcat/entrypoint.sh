#!/bin/bash
set -e

# preferable to fire up Tomcat via start-tomcat-docker.sh which will start Tomcat with
# security manager, but inheriting containers can also start Tomcat via
# catalina.sh

if [ "$1" = 'start-tomcat-docker.sh' ] || [ "$1" = 'catalina.sh' ]; then

    USER_ID=${TOMCAT_USER_ID:-1000}
    GROUP_ID=${TOMCAT_GROUP_ID:-1000}

    ###
    # Tomcat user
    ###
    groupadd -r tomcat-docker -g ${GROUP_ID} && \
    useradd -u ${USER_ID} -g tomcat-docker -d ${CATALINA_HOME} -s /sbin/nologin \
        -c "Tomcat user" tomcat-docker

    ###
    # Change CATALINA_HOME ownership to tomcat-docker user and tomcat-docker group
    # Restrict permissions on conf
    ###

    chown -R tomcat-docker:tomcat-docker ${CATALINA_HOME} && chmod 400 ${CATALINA_HOME}/conf/*
    sync
    exec gosu tomcat-docker "$@"
fi

exec "$@"